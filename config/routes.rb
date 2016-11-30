Rails.application.routes.draw do
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

  match '*all',to: 'application#options', via: :options


  # get '/day/:year/:month/:day' => 'schedule#day', constraints: {
  #     year:       /\d{4}/,
  #     month:      /\d{1,2}/,
  #     day:        /\d{1,2}/
  # }
end
