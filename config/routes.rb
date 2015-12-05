JellyfishAzure::Engine.routes.draw do
  resources :products, only: [] do
    member do
      get :locations
      get 'values/:parameter', to: 'products#parameter_values'
    end
  end
end
