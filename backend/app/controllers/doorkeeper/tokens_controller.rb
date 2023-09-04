# frozen_string_literal: true

module Doorkeeper
  class TokensController < Doorkeeper::ApplicationMetalController
    before_action :validate_presence_of_client, only: [:revoke]

    def create
      headers.merge!(authorize_response.headers)

      render json: authorize_response.body,
             status: authorize_response.status
    rescue Errors::DoorkeeperError => e
      handle_token_exception(e)
    end

    def revoke
      if token.blank?
        render json: {}, status: 200

      elsif authorized?
        revoke_token
        render json: {}, status: 200
      else
        render json: revocation_error_response, status: :forbidden
      end
    end

    def introspect
      introspection = OAuth::TokenIntrospection.new(server, token)

      if introspection.authorized?
        render json: introspection.to_json, status: 200
      else
        error = introspection.error_response
        headers.merge!(error.headers)
        render json: error.body, status: error.status
      end
    end

    private

    def validate_presence_of_client
      return if Doorkeeper.config.skip_client_authentication_for_password_grant

      return if server.client

      render json: revocation_error_response, status: :forbidden
    end

    def authorized?
      if token.application_id? && token.application.confidential?

        server.client && server.client.application == token.application
      else
        true
      end
    end

    def revoke_token
      token.revoke if token&.accessible?
    end

    def token
      @token ||= Doorkeeper.config.access_token_model.by_token(params['token']) ||
                 Doorkeeper.config.access_token_model.by_refresh_token(params['token'])
    end

    def strategy
      @strategy ||= server.token_request(params[:grant_type])
    end

    def authorize_response
      @authorize_response ||= begin
        before_successful_authorization
        auth = strategy.authorize
        context = build_context(auth:)
        after_successful_authorization(context) unless auth.is_a?(Doorkeeper::OAuth::ErrorResponse)
        auth
      end
    end

    def build_context(**attributes)
      Doorkeeper::OAuth::Hooks::Context.new(**attributes)
    end

    def before_successful_authorization(context = nil)
      Doorkeeper.config.before_successful_authorization.call(self, context)
    end

    def after_successful_authorization(context)
      Doorkeeper.config.after_successful_authorization.call(self, context)
    end

    def revocation_error_response
      error_description = I18n.t(:unauthorized, scope: %i[doorkeeper errors messages revoke])

      { error: :unauthorized_client, error_description: }
    end
  end
end
