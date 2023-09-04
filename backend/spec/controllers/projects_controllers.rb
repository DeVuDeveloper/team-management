# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:admin_user) { create(:admin) }
  let(:project) { create(:project) }

  before do
    sign_in admin_user
  end

  describe 'GET #index' do
    it 'responds with success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'redirects if signed out' do
      sign_out admin_user
      get :index
      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'GET #new' do
    it 'responds with success' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    it 'creates a new project' do
      expect do
        post :create, params: { project: { body: project.body, title: project.title } }
      end.to change(project, :count).by(1)

      expect(response).to redirect_to(project_url(project.last))
    end
  end

  describe 'GET #show' do
    it 'responds with success' do
      get :show, params: { id: project.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit' do
    it 'responds with success' do
      get :edit, params: { id: project.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH #update' do
    it 'updates the project' do
      patch :update, params: { id: project.id, project: { body: project.body, title: project.title } }
      expect(response).to redirect_to(project_url(project))
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the project' do
      project
      expect do
        delete :destroy, params: { id: project.id }
      end.to change(project, :count).by(-1)

      expect(response).to redirect_to(projects_url)
    end
  end
end
