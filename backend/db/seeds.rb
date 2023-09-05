# frozen_string_literal: true

if Doorkeeper::Application.count.zero?
  Doorkeeper::Application.create!(name: 'React', redirect_uri: '', scopes: '')
end

User.first_or_create(email: 'me@example.com',
                     password: 'password',
                     password_confirmation: 'password',
                     role: User.roles[:admin])
