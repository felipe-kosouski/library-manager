class DashboardsController < ApplicationController
  before_action :authorize_librarian!, only: [:librarian]
  before_action :authorize_member!, only: [:member]

  def index
  end

  def librarian
    @total_books = Book.count
    @total_borrowed_books = Book.total_borrowed
    @books_due_today = Borrowing.due_today
    @members_with_overdue_books = Borrowing.overdue.includes(:user).map(&:user).uniq
  end

  def member
    @borrowings = current_user.borrowed_books
    @overdue_books = current_user.overdue_books
  end
end
