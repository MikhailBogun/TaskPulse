require 'rails_helper'

RSpec.describe 'Auth API', type: :request do
  describe 'POST /api/v1/auth/register' do
    let(:valid_params) do
      { user: { email: 'test@example.com', password: 'password123', password_confirmation: 'password123' } }
    end

    it 'creates a user and returns 201' do
      post '/api/v1/auth/register', params: valid_params, as: :json
      expect(response).to have_http_status(:created)
      expect(json_response[:user][:email]).to eq('test@example.com')
    end

    it 'returns errors for invalid params' do
      post '/api/v1/auth/register', params: { user: { email: 'bad', password: 'short' } }, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:errors]).to be_present
    end
  end

  describe 'POST /api/v1/auth/login' do
    let!(:user) { create(:user, email: 'user@example.com', password: 'password123') }

    it 'returns JWT token on success' do
      post '/api/v1/auth/login', params: { user: { email: 'user@example.com', password: 'password123' } }, as: :json
      expect(response).to have_http_status(:ok)
      expect(json_response[:token]).to be_present
    end

    it 'returns 401 for wrong password' do
      post '/api/v1/auth/login', params: { user: { email: 'user@example.com', password: 'wrongpassword' } }, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET /api/v1/auth/me' do
    let(:user) { create(:user) }

    it 'returns current user data' do
      get '/api/v1/auth/me', headers: auth_headers_for(user)
      expect(response).to have_http_status(:ok)
      expect(json_response[:email]).to eq(user.email)
      expect(json_response[:plan]).to eq(user.plan)
    end

    it 'returns 401 without token' do
      get '/api/v1/auth/me'
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
