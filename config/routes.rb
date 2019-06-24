Rails.application.routes.draw do
  get '/docs' => redirect('/index.html?url=/api/v1/api-docs.json')

  namespace :api do
    namespace :v1 do
      resources :readings, only: [ :create, :show ]

      resources :thermo_stats, only: [ :index, :create, :show ] do
        collection do
          get :my_stats
        end
      end

    end
  end

  mount Sidekiq::Web, at: '/sidekiq'
end
