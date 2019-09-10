Rails.application.routes.draw do
  root 'sessions#new' # change to page with all commish options

  namespace 'commissioner' do
    get '/login' => 'sessions#new'
    post '/login' => 'sessions#create'
    get '/logout' => 'sessions#destroy'
  end

  # namespace 'commissioner' do
  #   transactions: new, create, edit, update, destroy (index for all to see)
  #   newsletter
  # end

  # namespace 'admin' do
  #   resources :players, only: [:new, :edit] # admin only in controller
  #   assigning players to teams (commish access?)
  #   whatever else
  # end

  # namespace 'api' do
  #   namespace 'v1' do
  #     resources :players, only: [:index, :show, :create, :update, :delete]
  #   end
  # end

end
