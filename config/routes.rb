JellyfishAzure::Engine.routes.draw do
  resources :providers, only: [] do
    member do
      get :azure_locations
      get :azure_resource_groups
    end
  end
end
