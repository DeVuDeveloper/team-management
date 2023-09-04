# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  root 'pages#home'
  use_doorkeeper
  devise_for :users
  resources :projects

  draw :api
end
