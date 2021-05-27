Rails.application.routes.draw do
  resources :courses
  root 'courses#index'
end
