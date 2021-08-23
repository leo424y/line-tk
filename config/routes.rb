Rails.application.routes.draw do
  resources :links
  root 'links#index'
  get :autocomplete_links, to: 'links#autocomplete'

  get '/',
  to: 'links#index',
  constraints: ->(request){ request.query_parameters["i"].present? }

  get '/:lihi', to: 'links#lihi'

  post '/callback', to: 'links#callback'
end
