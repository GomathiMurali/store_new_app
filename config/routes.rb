Rails.application.routes.draw do
 # scope "(:locale)", locale: /en|de/ do
  scope "(:locale)" do
   resources :products

   resources :orders
  
  get 'products/profit'
  get 'orders/fetch_product'
  get 'orders/add_line_item'
  get 'orders/states'
  get 'products/export_product'
  get 'products/index'
  #get 'products/pagination_params'
  get '/export_product', to: 'products#export_product'

 end

 #get 'products/pagination_next'
  #get 'products/fetch_countries'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
