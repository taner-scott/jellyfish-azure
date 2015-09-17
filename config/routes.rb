JellyfishAzure::Engine.routes.draw do
  resources :providers, only: [] do
    member do
      get :azure_locations
    end
  end
end
