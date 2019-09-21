Rails.application.routes.draw do

  namespace 'commissioner' do
    # Session
    get '/login' => 'sessions#new'
    post '/login' => 'sessions#create'
    get '/logout' => 'sessions#destroy'

    # Tools
    get '/' => 'tools#index' # link to all like CBS - should be commish homepage
    
    resources :trades, except: [:show, :edit, :update]
    #  Create newsletter, Trades, IR, Set keepers, Add players to team, Edit player points.
    #   Create/edit owners, 

    # Players
    get '/players/available' => 'players#available'
    post '/players/add-to-team' => 'players#add_to_team'
    # resources :players, only: [:new, :create, :edit, :update, :delete] - eventually admin_required

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
    
      # Team DST
      resources :team_dsts, only: [:index, :show]

      # Draft Picks
      resources :draft_picks, only: [:index, :show]

      # Trades
      resources :trades, only: [:index, :show]
    end
  end

end
