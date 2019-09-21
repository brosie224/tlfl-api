Rails.application.routes.draw do

  namespace 'commissioner' do
    # Session
    get '/login' => 'sessions#new'
    post '/login' => 'sessions#create'
    get '/logout' => 'sessions#destroy'

    # Tools
    get '/' => 'tools#index' # link to all like CBS - should be commish homepage
    #  Create Newsletter

    # Rosters
    get '/players/available' => 'players#available'
    post '/players/add-to-team' => 'players#add_to_team'
    # Set Keepers
    resources :trades, except: [:show, :edit, :update]

    # Players
    resources :injured_reserves, except: [:show, :destroy]
    # resources :players, only: [:new, :create, :edit, :update, :delete] - eventually admin_required
    # Edit Player Points

    # Owners
    get '/owners/assign' => 'owners#assign'
    post '/owners/add' => 'owners#add'
    # New/Create, Edit/Update Owners
  end

  namespace 'api' do
    namespace 'v1' do
      # TLFL Teams
      resources :tlfl_teams, only: [:index, :show]

      # Players
      get '/players/tlfl' => 'players#tlfl'
      get '/players/available' => 'players#available'
      resources :players, only: [:index, :show]
    
      # Team DST
      resources :team_dsts, only: [:index, :show]

      # Draft Picks
      resources :draft_picks, only: [:index, :show]

      # Trades
      resources :trades, only: [:index, :show]
    end
  end

end
