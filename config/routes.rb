Rails.application.routes.draw do
  root to: 'dashboard#index'

  get 'locations/current', :controller => 'locations', :action => 'current'
  get 'locations/server', :controller => 'locations', :action => 'server'
  get 'ping_results/recent', :controller => 'ping_results', :action => 'recent'
  resources :ping_results, :only => [:create, :show]

  if Rails.env.development? or Rails.env.test? or ENV['APP_STATUS'] =~ /staging/
    resources :locations
    resources :ping_results
  end
  #get 'dashboard/index'

  if ENV['LOADERIO_VERIFICATION_TOKEN'] and ENV['LOADERIO_VERIFICATION_FILENAME']
    get 'loaderio-:id' => 'loaderio#verify'
  end

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
