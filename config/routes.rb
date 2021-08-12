Rails.application.routes.draw do
  resources :lines
  root 'lines#index'
  get :autocomplete_lines, to: 'lines#autocomplete'
end
