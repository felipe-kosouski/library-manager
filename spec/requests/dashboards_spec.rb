require 'rails_helper'

RSpec.describe '/dashboards', type: :request do
  let!(:librarian) { create(:user, role: :librarian) }
  let!(:member) { create(:user, role: :member) }

  describe 'GET /librarian_dashboard' do
    context 'when the user is a librarian' do
      before do
        sign_in librarian
      end

      it 'renders a successful response' do
        get librarian_dashboard_url
        expect(response).to be_successful
      end
    end

    context 'when the user is a member' do
      before do
        sign_in member
      end

      it 'returns not authorized' do
        get librarian_dashboard_url
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /member_dashboard' do
    context 'when the user is a member' do
      before do
        sign_in member
      end

      it 'renders a successful response' do
        get member_dashboard_url
        expect(response).to be_successful
      end
    end

    context 'when the user is a librarian' do
      before do
        sign_in librarian
      end

      it 'returns not authorized' do
        get member_dashboard_url
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end