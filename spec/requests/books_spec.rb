require 'rails_helper'

RSpec.describe '/books', type: :request do
  let!(:books) { create_list(:book, 10) }

  describe "GET /books" do
    context "without search parameters" do
      before do
        get books_url
      end

      it "renders a successful response" do
        expect(response).to be_successful
      end

      it "returns all books" do
        expect(assigns(:books).count).to eq(10)
      end
    end

    context "with search parameters" do
      let!(:matching_book) { create(:book, title: "Matching Title", author: "Matching Author", genre: "Matching Genre") }

      before do
        get books_url, params: { title: "Matching", author: "Matching", genre: "Matching" }
      end

      it "renders a successful response" do
        expect(response).to be_successful
      end

      it "returns the matching books" do
        expect(assigns(:books)).to include(matching_book)
      end

      it "does not return non-matching books" do
        expect(assigns(:books)).to_not include(books.first)
      end
    end
  end

  describe "GET /books/:id" do
    before do
      get book_url(books.first)
    end

    it "renders a successful response" do
      expect(response).to be_successful
    end
  end

  context 'when the user is a librarian' do
    # before do
    #   librarian = create(:user, :librarian)
    #   sign_in librarian
    # end

    # describe 'GET /books/new' do
    #   it 'renders a successful response' do
    #     get new_book_url
    #     expect(response).to be_successful
    #   end
    # end

    # describe 'POST /books' do
    #   context 'with valid parameters' do
    #     let!(:book_params) { { book: { title: 'New Book', author: 'New Author', genre: 'New Genre', isbn: 'New ISBN', total_copies: 5 } } }
    #
    #     it 'creates a new book' do
    #       expect {
    #         post books_url, params: book_params
    #       }.to change(Book, :count).by(1)
    #     end
    #   end
    #
    #   context 'with invalid parameters' do
    #     let!(:book_params) { { book: { title: nil, author: nil, genre: nil, isbn: nil, total_copies: nil } } }
    #
    #     it 'does not create a new book' do
    #       expect {
    #         post books_url, params: book_params
    #       }.to_not change(Book, :count)
    #     end
    #   end
    # end

    # describe 'GET /books/:id/edit' do
    #   it 'renders a successful response' do
    #     get edit_book_url(books.first)
    #     expect(response).to be_successful
    #   end
    # end

  #   describe 'PUT /books/:id' do
  #     context 'with valid parameters' do
  #       let!(:book_params) { { book: { title: 'Updated Title' } } }
  #
  #       it 'updates the book' do
  #         put book_url(books.first), params: book_params
  #         expect(books.first.reload.title).to eq('Updated Title')
  #       end
  #     end
  #
  #     context 'with invalid parameters' do
  #       let!(:book_params) { { book: { title: nil } } }
  #
  #       it 'does not update the book' do
  #         put book_url(books.first), params: book_params
  #         expect(books.first.title).to_not be_nil
  #       end
  #     end
  #   end
  #
  #   describe 'DELETE /books/:id' do
  #     it 'destroys the requested book' do
  #       expect {
  #         delete book_url(books.first)
  #       }.to change(Book, :count).by(-1)
  #     end
  #   end
  end

  context 'when the user is a member' do
    # before do
    #   sign_in member_user
    # end

    # describe 'GET /books/new' do
    #   it 'raises Access Denied exception' do
    #     expect {
    #       get new_book_url
    #     }.to raise_error(CanCan::AccessDenied)
    #   end
    # end
    #
    # describe 'GET /books/:id/edit' do
    #   it 'raises Access Denied exception' do
    #     expect {
    #       get edit_book_url(books.first)
    #     }.to raise_error(CanCan::AccessDenied)
    #
    #   end
    # end
    #
    # describe 'POST /books' do
    #   it 'raises Access Denied exception' do
    #     expect {
    #       post books_url, params: { book: { title: 'New Book', author: 'New Author', genre: 'New Genre', isbn: 'New ISBN', total_copies: 5 } }
    #     }.to raise_error(CanCan::AccessDenied)
    #   end
    # end
    #
    # describe 'PUT /books/:id' do
    #   it 'raises Access Denied exception' do
    #     expect {
    #       put book_url(books.first), params: { book: { title: 'Updated Title' } }
    #     }.to raise_error(CanCan::AccessDenied)
    #   end
    # end
    #
    # describe 'DELETE /books/:id' do
    #   it 'raises Access Denied exception' do
    #     expect {
    #       delete book_url(books.first)
    #     }.to raise_error(CanCan::AccessDenied)
    #   end
    # end
  end
end