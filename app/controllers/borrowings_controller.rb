class BorrowingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:create]
  def index
    @borrowings = current_user.borrowings
  end

  def create
    if book.available_copies > 0
      current_user.borrowings.create!(book: book, borrowed_on: Date.today, due_on: 2.week.from_now)
      redirect_to borrowings_path, notice: "Book borrowed successfully."
    else
      redirect_to member_dashboard_path, alert: "Book is not available for borrowing."
    end
  end

  def return
    borrowing = current_user.borrowings.find(params[:id])
    borrowing.update!(returned_on: Date.today)
    redirect_to borrowings_path, notice: "Book returned successfully."
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end
end
