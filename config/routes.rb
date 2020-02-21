Rails.application.routes.draw do
  resources :url_mappings, only: [:create, :show, :destroy], param: :token

  # get 'url_mappings/:token', to: 'url_mappings#show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
