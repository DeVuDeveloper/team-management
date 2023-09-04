# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::RegistrationsController, type: :controller do
  before do
    @application = create(:doorkeeper_application)
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          email: 'test@example.com',
          password: 'password',
          client_id: @application.uid
        }
      end

      it 'creates a user and generates an access token' do
        expect do
          post :create, params: valid_params, format: :json
        end.to change { Doorkeeper::AccessToken.count }.by(1)
                                                       .and change { User.count }.by(1)

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          email: '',
          password: 'password',
          client_id: @application.uid
        }
      end

      it 'returns unprocessable entity status' do
        post :create, params: invalid_params, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to be_present
      end
    end

    context 'with invalid client_id' do
      let(:invalid_client_params) do
        {
          email: 'test@example.com',
          password: 'password',
          client_id: 'invalid_client_id'
        }
      end

      it 'returns unauthorized status' do
        post :create, params: invalid_client_params, format: :json

        expect(response).to have_http_status(:unauthorized)
        expect(json_response['error']).to eq('Client Not Found. Check Provided Client Id.')
      end
    end
  end
end
