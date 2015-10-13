JellyfishAzure::Engine.routes.draw do
  resources :providers, only: [] do
    member do
      get :web_dev_locations
    end
  end
end
