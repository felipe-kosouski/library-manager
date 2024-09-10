require 'rails_helper'

RSpec.describe "Api::V1::Borrowings", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/api/v1/borrowings/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /return" do
    it "returns http success" do
      get "/api/v1/borrowings/return"
      expect(response).to have_http_status(:success)
    end
  end

end
