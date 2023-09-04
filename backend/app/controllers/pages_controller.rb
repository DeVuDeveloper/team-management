# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @application = Doorkeeper::Application.find_by(name: 'React')

    @application = {
      name: @application.name,
      client_id: @application.uid,
      client_secret: @application.secret
    }
  end
end
