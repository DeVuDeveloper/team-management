# frozen_string_literal: true

Doorkeeper.configure do
  orm :active_record

  resource_owner_from_credentials do
    User.authenticate(params[:email], params[:password])
  end

  grant_flows %w[password]
  use_refresh_token
  allow_blank_redirect_uri true

  skip_authorization do
    true
  end
end
