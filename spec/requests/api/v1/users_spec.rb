require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) { create(:user) }
  let(:user_id) { user.id }

  before do
    headers = { "Accept" => "application/vnd.taskmanager.v1" }
  end

  describe 'GET /users/:id' do
    before do
      get "/api/users/#{user_id}", headers: headers
    end

    context 'when user exists' do
      it 'should return user object' do
        user_response =  JSON.parse(response.body)
        expect(user_response['id']).to eq user_id
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

  describe 'POST /users' do
    before do
      post '/api/users', params: { user: user_params }, headers: headers
    end

    context 'when the request params are valid' do
      let(:user_params) { attributes_for(:user) }

      it 'should returns status code 201' do
        expect(response).to have_http_status 201
      end

      it 'should returns json data for the created user' do
        user_response = JSON.parse(response.body)
        expect(user_response['email']).to eq user_params[:email]
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) { attributes_for(:user, email: 'invalid email')}

      it 'should returns status code 422' do
        expect(response).to have_http_status 422
      end

      it 'should the json data for the errors' do
        user_response = JSON.parse(response.body)
        expect(user_response).to have_key('errors')
      end
    end
  end
end