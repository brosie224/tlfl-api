Rails.application.routes.draw do
  root '/'

  get '/commissioner/login' => 'sessions#new'
  post '/commissioner/login' => 'sessions#create'
  get '/commissioner/logout' => 'sessions#destroy'
  
  # namespace 'commissioner' do
  #   transactions: new, create, edit, update, destroy (index for all to see)
  #   newsletter
  # end

  # namespace 'admin' do
  #   resources :players, only: [:new, :edit] # admin only in controller
  #   whatever else
  # end

  # namespace 'api' do
  #   namespace 'v1' do
  #     resources :players, only: [:index, :show, :create, :update, :delete]
  #   end
  # end

end
