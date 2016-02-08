Rails.application.routes.draw do

  devise_for :admins
  devise_for :users
  get 'users/new'

  get 'parseTournament' => 'parse_tournament#parse'
  post 'parseTournament' => 'parse_tournament#parse'

  get 'parseTournament/players' => 'parse_tournament#players'
  post 'parseTournament/players' => 'parse_tournament#players'
  get 'players/autocomplete_player_gamertag'
  post 'tournaments/getSetData' => 'tournaments#getSetData'
  post 'players/new' => 'players#new'
  post 'tournaments/createNewTournament' => 'tournaments#createNewTournament'
  post 'gamesets/intervalUpdate' => 'gamesets#intervalUpdate'
  get 'queryData' => 'query_data#query'

  resources :tournaments
  resources :gamesets
  resources :gamematchs
  resources :players

  post 'gamesets/update/:id' => 'gamesets#update'

  match '/contacts',     to: 'contacts#new',             via: 'get'
  resources "contacts", only: [:new, :create]

  root             'static_pages#home'
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  #get 'parseTournament' => 'static_pages#parseTournament'
  get 'createTournament' => 'static_pages#createTournament'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
