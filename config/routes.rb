Rails.application.routes.draw do

  get 'dso/echo'

  resources :macs

  get 'time' => 'dso#time'
  get 'sample' => 'dso#sample'
  get 'buzz' => 'dso#buzz'
  get 'client' => 'dso#client'
  post 'client' => 'dso#client'
end
