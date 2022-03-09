Rails.application.routes.draw do
  resources :x, controller: 'links'

  resources :links do
    get :like, on: :member
    get :skip, on: :member
    get :mail, on: :member
    get :tag, on: :member
  end


  resources :mails
  root 'links#index'
  get :autocomplete_links, to: 'links#autocomplete'

  get '/',
  to: 'links#index',
  constraints: ->(request){ request.query_parameters["i"].present? }

  get '/r', to: 'links#skip'
  get '/:lihi', to: 'links#lihi'

  get '/t/:tag', to: 'links#tag'

  post '/callback', to: 'links#callback'
end
