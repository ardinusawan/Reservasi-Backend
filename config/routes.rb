Rails.application.routes.draw do
  resources :schedules
  resources :bookings
  resources :types
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/now', to: 'schedules#now'
  get '/unapproved', to: 'bookings#unapproved'
  get '/approved', to: 'bookings#approved'

end
