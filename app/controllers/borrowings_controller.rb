class BorrowingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:create]
  before_action :set_user, only: [:create]
  before_action :set_borrowing, only: [:return]
  load_and_authorize_resource

  def index
    @borrowings = current_user.borrowings
  end

  # A future implementation could be refactoring the contents of this action to a service object
  # for better separation of concerns and to make the controller more readable
  # Also it would allow it to be reused in the API controller.
  def create
    if current_user.has_borrow_for_book?(@book)
      redirect_to member_dashboard_path, alert: "You have already borrowed this book."
    elsif @book.is_available?
      current_user.borrowings.create!(book: @book, user: @user, borrowed_on: Date.today, due_on: 2.weeks.from_now)
      redirect_to borrowings_path, notice: "Book borrowed successfully."
    else
      redirect_to member_dashboard_path, alert: "Book is not available for borrowing."
    end
  end

  # I would also refactor the return action contents to a separate service object for the same reasons
  # as the create borrowing action
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
