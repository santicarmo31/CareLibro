Rails.application.routes.draw do
  #rutas para los servicios mobiles
  namespace :api, defaults: { format: 'json' } do
   namespace :v1 do
     match "/login",to: "users#login", via: [:post]
     resources :users
     resources :posts
     resources :friendships
   end
 end


  #rutas para lso servicios web
  root 'welcome#home'
    resources :messages
  #match "/logout",to: "users#logout", via: [:delete], as: :logout #Es via delete por que voy a eliminar usuario
    match "/login",to: "users#login", via: [:post], as: :login # match dada una url deja usar varias vias. el as: es como lo voy a llamar desde la vista y el controlador. el primer string indica como sera la url.
    match "/posts/:id/comments/:comment/edit",to: "posts#show", via: [:get], as: "editcom"#El as como string es usado como metodo en donde en la url lo que tiene : son los atributos y para llamarlo desde vc utilizo editcom(argumento1, argumento2)
    get '/siginup' => 'users#new' #en la url usare signup para crear un nuevo usuario.
    delete '/logout' => 'users#logout'
    match "/:user_id/posts",to: "posts#index", via: [:get]
    get '/users/all' => 'users#index'
    match "/update/updatePassword",to: "users#updatePassword", via: [:get], as: :updatePassword
    resources :account_activations, only: [:edit,:update,:show]

    resources :users do
      resources :posts
    end
    resources :friendships
    resources :posts
    resources :comments
    match "/:id",to: "users#show", via: [:get]

    # The priority is based upon order of creation: first created -> highest priority.
    # See how all your routes lay out with "rake routes".

    # You can have the root of your site routed with "root"
    # root 'welcome#index'

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
