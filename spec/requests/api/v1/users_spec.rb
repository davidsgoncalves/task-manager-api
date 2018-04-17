require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:headers) do
    { 'Accept' => 'application/vnd.taskmanager.v1',
      'content-type' => Mime[:json].to_s }
  end

  before do
    headers = { "Accept" => "application/vnd.taskmanager.v1" }
  end

  describe 'GET /users/:id' do
    before do
      get "/api/users/#{user_id}", headers: headers
    end

    context 'when user exists' do
      it 'should return user object' do
        
        expect(json_body[:id]).to eq user_id
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
      post '/api/users', params: { user: user_params }.to_json, headers: headers
    end

    context 'when the request params are valid' do
      let(:user_params) { attributes_for(:user) }

      it 'should returns status code 201' do
        expect(response).to have_http_status 201
      end

      it 'should returns json data for the created user' do
        expect(json_body[:email]).to eq user_params[:email]
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) { attributes_for(:user, email: 'invalid email')}

      it 'should returns status code 422' do
        expect(response).to have_http_status 422
      end

      it 'should the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /users/:id' do
    before do
      put "/api/users/#{user_id}", params: { user: user_params }.to_json, headers: headers
    end

    context 'when the request params are valid' do
      let(:user_params) { {email: 'new@email.com'} }

      it 'returns status code 200' do
        expect(response).to have_http_status 200
      end

      it 'return the json data for the updated user' do
        expect(json_body[:email]).to eq user_params[:email]
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) {{ email: 'new@' }}

      it 'returns status code 422' do
        expect(response).to have_http_status 422
      end

      it 'should the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /users/:id' do
    before do
      delete "/api/users/#{user_id}", params: {}, headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status 204
    end

    it 'return the json data for the updated user' do
      expect(User.find_by(id: user.id)).to be_nil
    end
  end
end