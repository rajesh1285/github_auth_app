Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :github do
    collection do
    	get 'auth_callback'
    	get 'user_repos'
    end
  end

  root to: 'github#sign_in'
end