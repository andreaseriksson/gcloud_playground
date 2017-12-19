Rails.application.routes.draw do
  resources :companies
  root 'companies#index', as: :root
end
