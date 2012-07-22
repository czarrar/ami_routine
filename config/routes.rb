AmiRoutine::Application.routes.draw do
  get "home/index"
  get "home/contact"
  match '/home' => "home#index"
  
  devise_for :users, :path_prefix => 'd'
  devise_scope :user do
    get '/login' => 'devise/sessions#new'
    get '/logout' => 'devise/sessions#destroy'  
  end
  
  root :to => "home#index"
  
  resources :users
  
  resources :children
  
  resources :subjects
  
  match '/teacher_routines/calendar' => "teacher_routines#calendar", :as => "teacher_calendar"
  match '/teacher_routines/day/:date' => "teacher_routines#index"
  match '/teacher_routines/new' => "teacher_routines#new"
  match '/teacher_routines/create' => "teacher_routines#create"
  match '/teacher_routines/edit' => "teacher_routines#edit"
  match '/teacher_routines/update' => "teacher_routines#update"
  match '/teacher_routines/email' => "teacher_routines#email"
  
  match '/parent_routines/calendar' => "parent_routines#calendar", :as => "parent_calendar"
  match '/parent_routines/day/:date' => "parent_routines#index"
  
  match '/routines/calendar' => "routines#calendar", :as => "calendar"
  match '/routines/teacher/:day/:month/:year' => "routines#teacher"
  match '/routines/teacher_submit' => "routines#teacher_submit"
  match '/routines/parent/:day/:month/:year' => "routines#parent"
  resources :routines
  
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
