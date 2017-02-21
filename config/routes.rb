Rails.application.routes.draw do
  devise_for :users
  post 'auth_user' => 'authentication#authenticate_user'
  get 'home' => 'home#index'
  match '*all',to: 'application#options', via: :options
  get '/', :to => redirect('/index.html')

  # scope module: 'api' do
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :schedules do
        get 'now', on: :collection
        get ':date', to: 'schedules#date', on: :collection
        post 'conflict', on: :collection
      end
      resources :bookings do
        get 'unapproved', on: :collection
        get 'approved', on: :collection
      end
      resources :users do
        get 'nrp_nip/:nrp_nip', to: 'users#find_by_nrp_nip', on: :collection
      end
      resources :types

      #match '*all',to: 'application#options', via: :options
    end
  end
  #match '*all',to: 'application#options', via: :options
# end
end
