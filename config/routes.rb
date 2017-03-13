SpreeeedEngine::Engine.routes.draw do

  root to: 'scratch#hello'
  get 'scratch/index', to: 'scratch#index'
  get 'scratch/typeahead_data', to: 'scratch#typeahead_data'

  resources :fake_objects
  resources :fake_photos

end
