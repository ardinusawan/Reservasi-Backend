Rails.application.routes.draw do
  resources :schedules
  resources :bookings
  resources :types
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/now', to: 'schedules#now'
  get '/unapproved', to: 'bookings#unapproved'
  get '/approved', to: 'bookings#approved'
  get '/day/:date', to: 'schedules#day'
  # get '/day/:year/:month/:day' => 'schedule#day', constraints: {
  #     year:       /\d{4}/,
  #     month:      /\d{1,2}/,
  #     day:        /\d{1,2}/
  # }
  match 'options', to: 'bookings#options', via: :all

end
