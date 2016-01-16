Rails.application.routes.draw do

  get 'dso/echo'

  resources :macs

  get 'time' => 'dso#time'
  get 'sample' => 'dso#sample'
end
