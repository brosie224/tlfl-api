Rails.application.routes.draw do
  root 'commissioner/sessions#new' # change to page with all commish options

  namespace 'commissioner' do
    # Session
    get '/login' => 'sessions#new'
    post '/login' => 'sessions#create'
    get '/logout' => 'sessions#destroy'

    # Tools
    get '/tools' => 'tools#index'
    resources :trades, except: [:index]
    #   create newsletter

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

      # Trades
      get '/trades' => 'trades#index'
    end
  end

end
