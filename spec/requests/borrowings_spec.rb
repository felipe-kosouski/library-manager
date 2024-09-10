require 'rails_helper'

RSpec.describe '/borrowings', type: :request do
  let!(:user) { create(:user) }
  let!(:book) { create(:book, total_copies: 1) }

  before do
    sign_in user
  end

  describe 'GET /borrowings' do
    it 'renders a successful response' do
      get borrowings_url
      expect(response).to be_successful
    end
  end

  describe 'POST /borrowings' do
    let!(:borrowing_params) { { borrowing: { book_id: book.id, user_id: user.id } } }

    context 'when the book is available' do
      it 'creates a borrowing' do
        post borrowings_url, params: borrowing_params
        expect(response).to redirect_to(borrowings_url)
        expect(user.borrowings.count).to eq(1)
      end
    end

    context 'when the book is already borrowed by the user' do
      let!(:borrowing) { create(:borrowing, book: book, user: user) }

      it 'does not create a borrowing' do
        post borrowings_url, params: borrowing_params
        expect(response).to redirect_to(member_dashboard_url)
        expect(flash[:alert]).to eq('You have already borrowed this book.')
        expect(user.borrowings.count).to eq(1)
      end
    end

    context 'when the book is not available' do
      let!(:borrowing) { create(:borrowing, book: book, user: user) }
      let!(:new_user) { create(:user) }
      before do
        sign_in new_user
        borrowing_params[:borrowing][:user_id] = new_user.id
      end

      it 'does not create a borrowing' do
        post borrowings_url, params: borrowing_params
        expect(response).to redirect_to(member_dashboard_url)
        expect(flash[:alert]).to eq('Book is not available for borrowing.')
        expect(new_user.borrowings.count).to eq(0)
      end
    end
  end

  describe 'PATCH /borrowings/:id/return' do
    let!(:borrowing) { create(:borrowing, book: book, user: user) }
    context 'when the user is a librarian' do
      before do
        librarian = create(:user, :librarian)
        sign_in librarian
      end

      it 'marks the book as returned' do
        patch return_borrowing_url(borrowing)
        expect(response).to redirect_to(borrowings_url)
        expect(flash[:notice]).to eq('Book returned successfully.')
        expect(borrowing.reload.returned_on).to eq(Date.today)
      end
    end

    context 'when the user is not a librarian' do
      it 'returns not authorized status' do
        patch return_borrowing_url(borrowing)
        expect(response).to have_http_status(:unauthorized)
        expect(borrowing.returned_on).to be_nil
      end
    end
  end
end