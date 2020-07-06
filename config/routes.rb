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

  resources :reports, only: [:create] do
    get :autocomplete_category, :on => :collection
    get :autocomplete_config, :on => :collection
    # Search box
    collection do
      get :search
      post :import
    end
  end

  resources :posts, path: "/module", only: [:index, :show, :destroy] do
    resources :reports, only: [:show] do
      get :autocomplete_category_name, :on => :collection
      get :autocomplete_report_config, :on => :collection
      # Search box
      collection do
        get :search
      end
    end
    resources :categories, only: [:show]
    resources :source_files, path: "/file", only: [:index, :show, :destroy] do
      collection do
        delete :destroy_multiple
      end
    end
  end

  # For Build Dropdown Menu
  get "/update_builds_menu" => "products#update_builds_menu"

  get "/search_report" => "reports#search"

  # Check if user's password correct before delete account
  post "/delete_account" => "accounts#checkpass"

  get '*anything' => 'errors#routing_error'
end
