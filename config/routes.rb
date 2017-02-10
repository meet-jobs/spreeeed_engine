SpreeeedEngine::Engine.routes.draw do

  root to: 'scratch#hello'
  get 'scratch/index', to: 'scratch#index'

  resources :fake_objects
  resources :fake_photos

end
