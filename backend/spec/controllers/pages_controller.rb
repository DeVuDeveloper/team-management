# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  before do
    create(:doorkeeper_application)
  end

  describe 'GET #home' do
    it 'responds with success' do
      get :home
      expect(response).to have_http_status(:success)
    end
  end
end
