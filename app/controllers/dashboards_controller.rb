class DashboardsController < ApplicationController
  authorize_resource class: false, except: [:index]

  def index
    if user_signed_in?
      redirect_to current_user.librarian? ? librarian_dashboard_path : member_dashboard_path
    end
  end

  def librarian_dashboard
    authorize! :librarian_dashboard, :dashboard
    @total_books = Book.count
    @total_borrowed_books = Book.total_borrowed
    @books_due_today = Borrowing.due_today
    @members_with_overdue_books = Borrowing.overdue.includes(:user).map(&:user).uniq
  end

  def member_dashboard
    authorize! :member_dashboard, :dashboard
    @borrowings = current_user.borrowed_books
    @overdue_books = current_user.overdue_books
  end
end
