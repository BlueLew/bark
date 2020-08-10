Rails.application.routes.draw do
	root 'restaurants#index'

  resources :restaurants, except: [:index] do
  	delete :delete_image_attachment
    resources :reviews
  end
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
