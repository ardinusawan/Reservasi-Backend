Rails.application.routes.draw do
  resources :schedules
  # match 'schedules',to: 'schedules#options', via: :options
  resources :bookings
  # match 'bookings',to: 'bookings#options', via: :options
  resources :types
  # match 'types',to: 'types#options', via: :options
  resources :users
  # match 'users',to: 'users#options', via: :options
  # match 'users', :controller => 'users', :action => 'options', via: :options

  match '*all',to: 'application#options', via: :options

  get '/now', to: 'schedules#now'
  get '/unapproved', to: 'bookings#unapproved'
  get '/approved', to: 'bookings#approved'
  get '/day/:date', to: 'schedules#day'
  # get '/day/:year/:month/:day' => 'schedule#day', constraints: {
  #     year:       /\d{4}/,
  #     month:      /\d{1,2}/,
  #     day:        /\d{1,2}/
  # }

  # match 'options', to: 'bookings#options', via: :all

end
