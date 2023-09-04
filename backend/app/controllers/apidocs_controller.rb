# frozen_string_literal: true

class ApidocsController < ApplicationController
  include Swagger::Blocks

  swagger_root do
    key :openapi, '3.0.0'

    info do
      key :version, '1.0.0'
      key :title, 'Devise + Doorkeeper Starter'
      key :description, 'Devise + Doorkeeper Starter API documentation'

      contact do
        key :name, 'Devise + Doorkeeper Starter'
        key :url, 'https://lcalhost:3000'
        key :email, 'dejanvu.developer@gmail.com'
      end
    end

    server_url = Rails.env.development? ? 'http://localhost:3000' : 'https://your-production-url.com'
    server_description = 'TeamManagement API'

    server do
      key :url, "#{server_url}/api/v1/"
      key :description, server_description
    end
  end

  SWAGGERED_CLASSES = [
    Swagger::Controllers::Users::TokensController,
    Swagger::Controllers::Users::RegistrationsController,
    Swagger::Responses::Users::TokenResponses,
    Swagger::Responses::Users::RegistrationResponses,
    Swagger::Responses::ErrorResponse,
    Swagger::Inputs::Users::TokenInputs,
    Swagger::Inputs::Users::RegistrationInput,
    self
  ].freeze

  def index
    render html: nil, layout: 'swagger'
  end

  def data
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
