class BooksController < ApplicationController
  before_action :set_book, only: :show
  before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource

  def index
    search_params = params.slice(:title, :author, :genre)
    @books = search_params.present? ? Book.search(search_params) : Book.all
  end

  def show
  end

  private

  def set_book
    @book = Book.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end
end
