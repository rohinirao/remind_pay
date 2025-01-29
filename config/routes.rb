Rails.application.routes.draw do
  mount ActionCable.server => "/cable"

  resources :reminders

  root "reminders#index"
end
