Rails.application.routes.draw do
  resources :shortened_urls, only: [:create, :show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
