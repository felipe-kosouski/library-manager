class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    search_params = params.slice(:title, :author, :genre)
    @books = search_params.present? ? Book.search(search_params) : Book.all
  end

  def show
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to @book, notice: "Book was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: "Book was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to books_url, notice: "Book was successfully destroyed."
  end

  private

  def book_params
    params.require(:book).permit(:title, :author, :genre, :isbn, :total_copies)
  end

  def set_book
    @book = Book.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end
end
