require 'rails_helper'

RSpec.describe "Api::V1::Books", type: :request do
  describe "GET /api/v1/books/:id" do
    let!(:book) { create(:book) }

    it "returns a book" do
      get api_v1_book_url(book), as: :json
      expect(response).to have_http_status(:ok)
    end
  end

end
