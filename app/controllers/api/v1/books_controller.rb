class Api::V1::BooksController < Api::ApplicationController
  before_action :set_book, only: [:show, :update, :destroy]

  def_param_group :book do
    property :id, Integer, desc: 'Book ID'
    property :title, String, desc: 'Book title'
    property :author, String, desc: 'Book author'
    property :genre, String, desc: 'Book genre'
    property :isbn, String, desc: 'Book ISBN'
    property :total_copies, Integer, desc: 'Total copies of the book'
  end

  api :GET, '/v1/books', 'Retrieves a list of books'
  format 'json'
  param :title, String, desc: 'Search by book title', allow_nil: true, allow_blank: true
  param :author, String, desc: 'Search by book author', allow_nil: true, allow_blank: true
  param :genre, String, desc: 'Search by book genre', allow_nil: true, allow_blank: true
  returns array_of: :book, code: :ok
  def index
    search_params = params.slice(:title, :author, :genre)
    @books = search_params.present? ? Book.search(search_params) : Book.all
    render json: @books
  end

  api :GET, '/v1/books/:id', 'Retrieves a book by its ID'
  format 'json'
  error code: 404, desc: 'Not Found'
  param :id, :number, desc: 'Book ID', required: true
  returns :book, code: :ok
  def show
    render json: @book, status: :ok
  end


  api :POST, '/v1/books', 'Creates a new book'
  format 'json'
  error code: 422, desc: 'Unprocessable Entity'
  param_group :book, as: :create
  returns :book, code: :created
  def create
    @book = Book.new(book_params)
    if @book.save
      render json: @book, status: :created
    else
      render json: @book.errors, status: :unprocessable_content
    end
  end

  api :PATCH, '/v1/books/:id', 'Updates a book'
  format 'json'
  error code: 404, desc: 'Not Found'
  error code: 422, desc: 'Unprocessable Entity'
  param :id, :number, desc: 'Book ID', required: true
  param_group :book, as: :update
  returns :book, code: :ok
  def update
    if @book.update(book_params)
      render json: @book, status: :ok
    else
      render json: @book.errors, status: :unprocessable_content
    end
  end

  api :DELETE, '/v1/books/:id', 'Deletes a book'
  error code: 404, desc: 'Not Found'
  param :id, :number, desc: 'Book ID', required: true
  returns code: :no_content
  def destroy
    @book.destroy
    render json: { message: 'Book was successfully destroyed.' }, status: :no_content
  end

  private

  def book_params
    params.require(:book).permit(:title, :author, :genre, :isbn, :total_copies)
  end

  def set_book
    @book = Book.find(params[:id])
  end
end
