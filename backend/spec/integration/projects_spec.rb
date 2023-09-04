# frozen_string_literal: true

require 'swagger_helper'
require 'rails_helper'

describe 'Projects API' do # rubocop:disable Metrics/BlockLength
  before do
    @token = "Bearer #{create(:doorkeeper_access_token).token}"
    @project = create(:project).attributes
  end

  path '/api/v1/projects' do
    get 'Get all projects' do
      tags 'projects'
      security [Bearer: []]
      parameter name: :Authorization, in: :header, type: :string, required: true,
                description: 'Authorization token'
      response '200', 'projects found' do
        let(:Authorization) { @token }
        run_test!
      end
      response '401', 'unauthorized' do
        let(:Authorization) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/projects/{id}' do
    get 'Get a project' do
      tags 'Projects'
      security [Bearer: []]
      parameter name: :Authorization, in: :header, type: :string, required: true,
                description: 'Authorization token'
      parameter name: :id, in: :path, type: :string, required: true,
                description: 'ID of the project'
      response '200', 'project found' do
        let(:Authorization) { @token }
        let(:id) { @project['id'] }
        run_test!
      end
      response '404', 'project not found' do
        let(:Authorization) { @token }
        let(:id) { 'invalid' }
        run_test!
      end
      response '401', 'unauthorized' do
        let(:Authorization) { 'invalid' }
        let(:id) { @project['id'] }
        run_test!
      end
    end
  end

  path '/api/v1/projects' do
    post 'Create a project' do
      tags 'Projects'
      consumes 'application/json', 'application/xml'
      security [Bearer: []]
      parameter name: :Authorization, in: :header, type: :string, required: true,
                description: 'Authorization token'
      parameter name: :project, in: :body, schema: {
        type: :object,
        properties: {
          project: {

            name: { type: :string },
            description: { type: :string }
          }
        },
        required: %w[name description]
      }
      response '302', 'redirected' do
        let(:Authorization) { @token }
        let(:project) { { name: 'Teams', description: 'A great project' } }
        run_test!
      end
      response '401', 'unauthorized' do
        let(:Authorization) { 'invalid' }
        let(:project) { { project: attributes_for(:project) } }
        run_test!
      end
    end
  end
end
