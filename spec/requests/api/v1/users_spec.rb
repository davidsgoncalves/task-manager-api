require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) { create(:user) }
  let(:user_id) { user.id }

  describe 'GET users/:id' do
    before do
      headers = { "Accept" => "application/vnd.taskmanager.v1" }
      get "/api/users/#{user_id}", headers: headers
    end

    context 'when user exists' do
      it 'should return user object' do
        user_response =  JSON.parse(response.body)
        expect(user_response["id"]).to eq user_id
      end

      it 'should return http status 200' do
        expect(response).to have_http_status 200
      end
    end

    context 'when user does not exists' do
      let(:user_id) { 100000 }

      it 'should return http status 404' do
        expect(response).to have_http_status 404
      end
    end
  end
end