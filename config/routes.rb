Rails.application.routes.draw do
  resources :lines
  root 'lines#index'
  get :autocomplete_lines, to: 'lines#autocomplete'

  get 'lines',
  to: 'lines#index',
  constraints: ->(request){ request.query_parameters["i"].present? }

  get '/:lihi', to: 'lines#lihi'
end
