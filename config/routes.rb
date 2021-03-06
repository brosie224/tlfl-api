Rails.application.routes.draw do

  namespace 'commissioner' do
    # SESSION
    get '/login' => 'sessions#new'
    post '/login' => 'sessions#create'
    get '/logout' => 'sessions#destroy'

    # TOOLS
    get '/' => 'tools#index'
    get '/update-available-players' => 'tools#update_available_players'
    #  Create Newsletter

    # PLAYERS
    # Assign/Keepers
    get '/players/assign' => 'players#assign'
    post '/players/add-to-team' => 'players#add_to_team'
    patch '/players/remove-from-team/:id' => 'players#remove_from_team'
    patch '/players/remove-dst/:id' => 'players#remove_dst'
    get '/players/edit-seniority' => 'players#edit_seniority'
    patch '/players/update-seniority' => 'players#update_seniority'
    # Set Keepers
    resources :players, only: [:edit, :update]

    # Trades
    resources :trades, except: [:show, :edit, :update]

    # Reserves
    resources :reserves, except: [:show, :destroy, :update, :edit]
    get '/reserves/activate-replace' => 'reserves#activate_or_replace'
    post '/reserves/activate' => 'reserves#activate'
    post '/reserves/change-replacement' => 'reserves#change_replacement'

    # resources :players, only: [:new, :create, :edit, :update, :delete] - eventually admin_required
    # Edit Player Points

    # OWNERS
    get '/owners/assign' => 'owners#assign'
    post '/owners/add' => 'owners#add'
    # Index, New/Create, Edit/Update, Delete Owners
  end

  namespace 'api' do
    namespace 'v1' do
      # TLFL TEAMS
      resources :tlfl_teams, only: [:index, :show]

      # PLAYERS
      get '/players/tlfl' => 'players#tlfl'
      get '/players/available' => 'players#available'
      resources :players, only: [:index, :show]
    
      # TEAM DST
      resources :team_dsts, only: [:index, :show]

      # DRAFT PICKS
      resources :draft_picks, only: [:index, :show]

      # TRADES
      resources :trades, only: [:index, :show]

      # RESERVES
      get '/reserves' => 'reserves#index'

      # SCHEDULE
      get '/schedule' => 'schedule_games#index'

    end
  end

end
