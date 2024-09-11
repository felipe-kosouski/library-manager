require 'rails_helper'

RSpec.describe "Api::V1::Borrowings", type: :request do
  describe "GET /api/v1/borrowings" do
    let!(:borrowing1) { create(:borrowing) }
    let!(:borrowing2) { create(:borrowing) }

    it "retrieves a list of borrowings" do
      get api_v1_borrowings_url, as: :json
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(borrowing1.id.to_s, borrowing2.id.to_s)
    end
  end

  describe "GET /api/v1/borrowings/:id" do
    let!(:borrowing) { create(:borrowing) }

    context 'when the borrowing exists' do
      it "retrieves a borrowing by its ID" do
        get api_v1_borrowing_url(borrowing), as: :json
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(borrowing.id.to_s)
      end
    end

    context 'when the borrowing does not exists' do
      it "returns 404" do
        get api_v1_borrowing_url(id: -1), as: :json
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /api/v1/borrowings" do
    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let(:borrowing_params) { { book_id: book.id, user_id: user.id } }

    context 'when the book is available' do
      it "creates a new borrowing" do
        expect {
          post api_v1_borrowings_url, params: { borrowing: borrowing_params }, as: :json
        }.to change(Borrowing, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'when the book is not available' do
      before do
        allow_any_instance_of(Book).to receive(:is_available?).and_return(false)
        post api_v1_borrowings_url, params: { borrowing: borrowing_params }, as: :json
      end

      it "returns unprocessable entity" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        expect(response.body).to include("Book is not available for borrowing.")
      end
    end

    context 'with invalid params' do
      let(:borrowing_invalid_params) { { book_id: nil, user_id: nil } }
      it "does not create a new borrowing" do
        expect {
          post api_v1_borrowings_url, params: { borrowing: borrowing_invalid_params }, as: :json
        }.not_to change(Borrowing, :count)

      end

      it 'returns 404' do
        post api_v1_borrowings_url, params: { borrowing: borrowing_invalid_params }, as: :json
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the user has already borrowed the book' do
      before do
        create(:borrowing, book: book, user: user)
        post api_v1_borrowings_url, params: { borrowing: borrowing_params }, as: :json
      end

      it 'returns unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        expect(response.body).to include("You have already borrowed this book.")
      end
    end
  end

  describe "PATCH /api/v1/borrowings/:id" do
    let!(:borrowing) { create(:borrowing) }
    let(:invalid_attributes) { { due_on: nil } }

    context 'with valid params' do
      let(:borrowing_params) { { due_on: 3.weeks.from_now } }
      before do
        patch api_v1_borrowing_url(borrowing), params: { borrowing: borrowing_params }, as: :json
        borrowing.reload
      end
      it "updates the borrowing" do
        expect(borrowing.due_on).to eq(3.weeks.from_now.to_date)
      end

      it 'returns status ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      before do
        patch api_v1_borrowing_url(borrowing), params: { borrowing: invalid_attributes }, as: :json
        borrowing.reload
      end
      it "does not update the borrowing" do
        expect(borrowing.due_on).not_to be_nil
      end

      it 'returns unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /api/v1/borrowings/:id" do
    let!(:borrowing) { create(:borrowing) }

    context 'when the borrowing exists' do
      it "deletes the borrowing" do
        expect {
          delete api_v1_borrowing_url(borrowing), as: :json
        }.to change(Borrowing, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the borrowing does not exists' do
      it "returns 404" do
        expect {
          delete api_v1_borrowing_url(id: -1), as: :json
        }.not_to change(Borrowing, :count)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "PATCH /api/v1/borrowings/:id/return" do
    let!(:borrowing) { create(:borrowing) }

    it "returns the book successfully" do
      patch return_api_v1_borrowing_url(borrowing), as: :json
      borrowing.reload
      expect(borrowing.returned_on).to eq(Time.zone.today)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Book returned successfully.")
    end

    context 'when the borrowing does not exists' do
      it 'returns 404' do
        patch return_api_v1_borrowing_url(id: -1), as: :json
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
