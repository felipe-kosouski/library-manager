class BorrowingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:create]
  before_action :set_user, only: [:create]
  before_action :set_borrowing, only: [:return]
  before_action :authenticate_user!
  before_action :authorize_librarian!, only: [:return]

  def index
    @borrowings = current_user.borrowings
  end

  def create
    if current_user.has_borrow_for_book?(@book)
      redirect_to member_dashboard_path, alert: "You have already borrowed this book."
    elsif @book.is_available?
      #extract this to a service maybe
      current_user.borrowings.create!(book: @book, user: @user, borrowed_on: Date.today, due_on: 2.weeks.from_now)
      redirect_to borrowings_path, notice: "Book borrowed successfully."
    else
      redirect_to member_dashboard_path, alert: "Book is not available for borrowing."
    end
  end

  def return
    @borrowing.update!(returned_on: Date.today)
    redirect_to borrowings_path, notice: "Book returned successfully."
  end

  private

  def create_params
    params.require(:borrowing).permit(:book_id, :user_id)
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
