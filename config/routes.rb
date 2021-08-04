Rails.application.routes.draw do
  resources :lines
  root 'lines#index'
end
