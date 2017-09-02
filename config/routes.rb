Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, default: {format: :json} do
    get '/collections' => 'collections#get_data', as: "get_data"
  end
end
