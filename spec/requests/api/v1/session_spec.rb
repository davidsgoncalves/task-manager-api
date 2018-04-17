require 'rails_helper'

RSpec.describe 'Session API', type: :request do
  let(:user) do
    User.create! password: '123456', password_confirmation: '123456', email: 'test@test.com'
    User.first
  end
  let(:headers) do
    { 'Accept' => 'application/vnd.taskmanager.v1',
      'content-type' => Mime[:json].to_s }
  end

  describe 'POST /sessions' do
    before do
      post '/api/sessions', params: { session: credentials }.to_json, headers: headers

    end

    context 'when the credentials are correct' do
      let(:credentials) { { email: user.email, password: '123456' }}

      it 'should return status code 200' do
        expect(response).to have_http_status 200
      end

      it 'should return the json data for the user with auth token' do
        user.reload
        expect(json_body[:auth_token]).to eq user.auth_token
      end
    end

    context 'when the credentials are not correct' do
      let(:credentials) { { email: user.email, password: 'anypass' }}

      it 'should return status code 401' do
        expect(response).to have_http_status 401
      end

      it 'should return the json data for the user with auth token' do
        user.reload
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /sessions/:id' do
    let(:auth_token) { user.auth_token }
    before do
      delete "/api/sessions/#{auth_token}", params: {}, headers: headers
    end

    it 'should returns status code 204' do
      expect(response).to have_http_status 204
    end

    it 'should change the user auth token' do
      expect(User.find_by(auth_token: auth_token)).to be_nil
    end
  end
end