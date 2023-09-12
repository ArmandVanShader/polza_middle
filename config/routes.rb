Rails.application.routes.draw do
  root "orders#home"

  get '/orders', to: 'orders#index'
  post '/orders', to: 'orders#create'

  get 'orders/new'
  get 'orders/generate/:count', to: 'orders#generate'
  get 'orders/generate/', to: 'orders#generate'
  get 'orders/delete', to: 'orders#delete'
  get 'orders/summary', to: 'orders#summary'

  get 'import', to: 'dishs#import'

end
