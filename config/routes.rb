Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :scrappers

    end
  end
  root :to => "api/v1/scrappers#index"
end
