Rails.application.routes.draw do
  use_doorkeeper
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # Extending Devise - Custom Routing
  devise_for :users,
    path: '', # optional namespace or empty string for no space
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      password: 'secret',
      confirmation: 'verification',
      registration: 'register',
      sign_up: 'signup',
      invitation: 'invite'
    }
  root 'home#index'
end
