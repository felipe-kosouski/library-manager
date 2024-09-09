class ApplicationController < ActionController::Base
  def authorize_librarian!
    unless current_user.librarian?
      redirect_to root_path, alert: "Access denied.", status: :unauthorized
    end
  end
end
