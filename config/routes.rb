Rails.application.routes.draw do
  resources :cars do
    member do
      get 'claim' => 'cars#claim'
      get 'unclaim' => 'cars#unclaim'
    end
    collection do
      # Links for collection
    end
  end
  root 'cars#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'my_cars' => 'cars#my_cars'
  get 'about' => 'static_pages#about'

  resources :users,
    only: [ :new, :create ],
    path_names: { new: 'signup' }

  get 'login' => 'sessions#login'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
end
