Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'api/collections#index'

  namespace :api, default: {format: :json} do
    get '/collections' => 'collections#get_data', as: "get_data"
    get 'collections/data.csv' => 'collections#data_to_csv', as: "data_to_csv"
    get 'collections/data_fetches' => 'collections#all_data_fetches', as: 'all_data_fetches'
    get 'collections/data_fetch' => 'collections#data_fetch', as: 'data_fetch'
    get 'collections/brands' => 'collections#all_brands', as: 'all_brands'
    get 'collections/brand' => 'collections#get_brand', as: 'get_brand'
    get 'collections/products' => 'collections#all_products', as: 'all_products'
    get 'collections/product' => 'collections#get_product', as: 'get_product'
  end
end
