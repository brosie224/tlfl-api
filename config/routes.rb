Rails.application.routes.draw do
  root 'commissioner/sessions#new' # change to page with all commish options

  namespace 'commissioner' do
    # Session
    get '/login' => 'sessions#new'
    post '/login' => 'sessions#create'
    get '/logout' => 'sessions#destroy'

    # Tools
    get '/tools' => 'tools#index'
    #   transactions: new, create, edit, update, destroy (index for all to see)
    #   newsletter

    # Players
    get '/players/available' => 'players#available'
    post '/players/add-to-team' => 'players#add_to_team'

    # Owners
    get '/owners/assign' => 'owners#assign'
    post '/owners/add' => 'owners#add'
  end

  namespace 'api' do
    namespace 'v1' do
      # TLFL Teams
      resources :tlfl_teams, only: [:index, :show]

      # Players
      get '/players/tlfl' => 'players#tlfl'
      get '/players/available' => 'players#available'
      resources :players, only: [:index, :show]
      # resources :players, only: [:index, :show, :create?, :update?, :delete]
    end
  end

# Need or just use admin_required before specific methods
  # namespace 'admin' do
  #   resources :players, only: [:new?, :edit?] # admin only in controller
  #   assigning players to teams (commish access?)
  #   whatever else
  # end

end
