require 'rails_helper'

RSpec.describe "Api::V1::Books", type: :request do
  describe "GET /api/v1/books" do
    let!(:book1) { create(:book, title: "Book One", author: "Author One", genre: "Genre One") }
    let!(:book2) { create(:book, title: "Book Two", author: "Author Two", genre: "Genre Two") }

    context 'when no search parameters are provided' do
      it "returns all books" do
        get api_v1_books_url, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(book1.title, book2.title)
      end
    end

    context 'when search parameters are provided' do
      it "returns books matching the title" do
        get api_v1_books_url, params: { title: "Book One" }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(book1.title)
        expect(response.body).not_to include(book2.title)
      end

      it "returns books matching the author" do
        get api_v1_books_url, params: { author: "Author Two" }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(book2.title)
        expect(response.body).not_to include(book1.title)
      end

      it "returns books matching the genre" do
        get api_v1_books_url, params: { genre: "Genre One" }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(book1.title)
        expect(response.body).not_to include(book2.title)
      end
    end

    context 'when no books match the search parameters' do
      it "returns an empty array" do
        get api_v1_books_url, params: { title: "Nonexistent Book" }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq("[]")
      end
    end
  end

  describe "GET /api/v1/books/:id" do
    let!(:book) { create(:book) }

    context 'when the book exists' do
      it "returns the book" do
        get api_v1_book_url(book), as: :json
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(book.title)
      end
    end

    context 'when the book does not exists' do
      it 'returns 404' do
        get api_v1_book_url(id: -1), as: :json
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /api/v1/books" do
    context 'with valid params' do
      let(:book_params) { { title: "New Book", author: "Author", genre: "Genre", isbn: "1234567890", total_copies: 5 } }
      it 'creates a new book' do
        expect {
          post api_v1_books_url, params: { book: book_params }, as: :json
        }.to change(Book, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      let(:book_params) { { title: "", author: "", genre: "", isbn: "", total_copies: 0 } }
      it 'does not create a new book' do
        expect {
          post api_v1_books_url, params: { book: book_params }, as: :json
        }.not_to change(Book, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /api/v1/books/:id" do
    let!(:book) { create(:book) }

    context 'with valid params' do
      let(:book_params) { { title: "Updated Title" } }
      it 'updates the book' do
        patch api_v1_book_url(book), params: { book: book_params }, as: :json
        book.reload
        expect(book.title).to eq("Updated Title")
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:book_params) { { title: "" } }
      it 'does not update the book' do
        patch api_v1_book_url(book), params: { book: book_params }, as: :json
        book.reload
        expect(book.title).not_to eq("")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /api/v1/books/:id" do
    let!(:book) { create(:book) }

    context 'when the book exists' do
      it "deletes the book" do
        expect {
          delete api_v1_book_url(book), as: :json
        }.to change(Book, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the book does not exist' do
      it 'returns 404' do
        expect {
          delete api_v1_book_url(id: -1), as: :json
        }.not_to change(Book, :count)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end