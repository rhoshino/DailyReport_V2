Rails.application.routes.draw do


  get 'month_report/:year/:month' => 'reports#month_report',
    constraints: lambda { |request| Date.valid_date?(request.params[:year].to_i, request.params[:month].to_i, 1)},
    as: "month_report"

  # match'change_year_and_month' => 'reports#change_year_and_month',via: :get

  resources :reports

  match "user_reports", to: 'reports#user_reports', via: 'get'
  match "public_user_reports", to:'reports#public_user_reports', via: 'get'
  match "draft_user_reports", to:'reports#draft_user_reports', via: 'get'
  # match "month_report/:month", to:'reports#month_report',via: 'get'



  devise_for :users, controllers: {sessions: "sessions/sessions",
                                    registrations: "sessions/registrations"}
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'users#home'
  get "users/show"

  get "foobar/hoge"


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
