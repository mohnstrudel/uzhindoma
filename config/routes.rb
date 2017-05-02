Rails.application.routes.draw do

  authenticated :admin, -> admin { admin.has_rights? } do
    mount Delayed::Web::Engine, at: '/jobs'
  end
  # mount Delayed::Web::Engine, at: '/jobs'
  devise_for :admins, 
        controllers: {
          sessions: 'front/admins/sessions',
          registrations: 'front/admins/registrations'
        }
  # namespace :front do
  # get 'users/profile'
  # end


  # root 'static_pages#home'


  # devise_for :users, controllers: {
  #       registrations: 'admin/users/registrations'
  #       # registrations: 'front/users/registrations'
  #     }
  devise_for :users, controllers: {
        sessions: 'front/users/sessions',
        registrations: 'front/users/registrations'
      }, path: '', path_names: { 
        sign_in: 'signin', 
        sign_out: 'signout', 
        sign_up: 'register', 
        edit: 'profile' }
  
  get 'reset_password', to: 'front/profile#change_password'
  
  namespace :admin do
    get '', to: 'dashboard#index', as: '/'
    resources :recipes
    resources :menus
    resources :categories
    resources :users
    resources :orders
    resources :settings
    resources :employees
    resources :jobtitles
    resources :partners
    resources :igrams
    resources :personamounts
    resources :days
    resources :promocodes
    resources :feedbacks, only: [:show, :index]
  end


  scope module: :front do
    root 'static_pages#home'
    get 'uznat-bolshe', to: 'static_pages#learn_more'
    get 'policy', to: 'static_pages#policy'
    get 'out_of_order', to: 'orders#out_of_order'

    get 'process_order', to: 'orders#process_order'

    get 'send_sms', to: 'profile#generate_password'

    resources :menus
    resources :dinner
    resources :orders
    resources :payments
    resources :feedbacks, only: [:create, :new]
    
    get 'bitrix', to: 'bitrix#index'
    get 'bitrix/new' => 'bitrix#create_new_order', :as => :new_bitrix_order
  end

  # authenticated :admin, -> admin { admin.roles{:admin} }  do
  #   mount DelayedJobWeb, at: "/delayed_job"
  # end


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
