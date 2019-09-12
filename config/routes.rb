Rails.application.routes.draw do
  root 'commissioner/sessions#new' # change to page with all commish options

  namespace 'commissioner' do
    get '/login' => 'sessions#new'
    post '/login' => 'sessions#create'
    get '/logout' => 'sessions#destroy'
    get '/assign' => 'owners#assign'
    post '/add' => 'owners#add'
    #   transactions: new, create, edit, update, destroy (index for all to see)
    #   newsletter
  end

  namespace 'api' do
    namespace 'v1' do
      resources :tlfl_teams, only: [:index, :show]
      resources :owners, only: [:index, :show]
      get '/players/tlfl' => 'players#tlfl'
      get '/players/available' => 'players#available'
      resources :players, only: [:index, :show]
      # resources :players, only: [:index, :show, :create?, :update?, :delete]
    end
  end

  # namespace 'admin' do
  #   resources :players, only: [:new?, :edit?] # admin only in controller
  #   assigning players to teams (commish access?)
  #   whatever else
  # end

end
