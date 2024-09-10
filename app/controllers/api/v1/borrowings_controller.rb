class Api::V1::BorrowingsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_book, only: [:create]
  before_action :set_user, only: [:create]
  before_action :set_borrowing, only: [:show, :update, :destroy, :return]
  # before_action :authenticate_user!
  # before_action :authorize_librarian!, only: [:return]

  def_param_group :borrowing do
    property :id, Integer, desc: 'Borrowing ID'
    property :book_id, Integer, desc: 'Book ID'
    property :user_id, Integer, desc: 'User ID'
    property :borrowed_on, Date, desc: 'Date borrowed'
    property :due_on, Date, desc: 'Date due'
  end

  api :GET, '/v1/borrowings', 'Retrieves a list of borrowings'
  format 'json'
  returns array_of: :borrowing, code: :ok
  def index
    render json: Borrowing.all
  end

  api :GET, '/v1/borrowings/:id', 'Retrieves a borrowing by its ID'
  format 'json'
  param :id, :number, desc: 'Borrowing ID', required: true
  returns :borrowing, code: :ok
  def show
    render json: @borrowing
  end

  api :POST, '/v1/borrowings', 'Creates a new borrowing'
  format 'json'
  param_group :borrowing, as: :create
  returns :borrowing, code: :created
  def create
    # if current_user.has_borrow_for_book?(@book)
    if @user.has_borrow_for_book?(@book)
      render json: { message: "You have already borrowed this book." }, status: :unprocessable_content
    elsif @book.is_available?
      # current_user.borrowings.create!(book: @book, user: @user, borrowed_on: Time.zone.today, due_on: 2.week.from_now)
      borrowing = @user.borrowings.create!(book: @book, user: @user, borrowed_on: Time.zone.today, due_on: 2.week.from_now)
      render json: { borrowing: borrowing, message: "Book borrowed successfully." }, status: :created
    else
      render json: { message: "Book is not available for borrowing." }, status: :unprocessable_content
    end
  end

  api :PATCH, '/v1/borrowings/:id', 'Updates a borrowing'
  format 'json'
  param :id, :number, desc: 'Borrowing ID', required: true
  param_group :borrowing, as: :update
  returns :borrowing, code: :ok
  def update
    if @borrowing.update(update_params)
      render json: @borrowing, status: :ok
    else
      render json: @borrowing.errors, status: :unprocessable_content
    end
  end

  api :DELETE, '/v1/borrowings/:id', 'Deletes a borrowing'
  param :id, :number, desc: 'Borrowing ID', required: true
  returns code: :no_content
  def destroy
    @borrowing.destroy
    render json: { message: 'Borrowing was successfully destroyed.' }, status: :no_content
  end

  api :PATCH, '/v1/borrowings/:id/return', 'Returns a borrowing'
  format 'json'
  param :id, :number, desc: 'Borrowing ID', required: true
  returns code: :ok
  def return
    @borrowing.update!(returned_on: Time.zone.today)
    render json: { message: "Book returned successfully." }, status: :ok
  end

  private

  def create_params
    params.require(:borrowing).permit(:book_id, :user_id)
  end

  def update_params
    params.require(:borrowing).permit(:due_on, :borrowed_on)
  end

  def set_user
    @user = User.find(params[:borrowing][:user_id])
  end

  def set_book
    @book = Book.find(params[:borrowing][:book_id])
  end

  def set_borrowing
    @borrowing = Borrowing.find(params[:id])
  end
end
