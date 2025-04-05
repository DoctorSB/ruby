Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  namespace :admin do
    resources :users, only: [:index, :edit, :update]
  end
  resources :products do
    collection do
      get :search # маршрут для поиска продуктов по категориям и по названию
    end
  end

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA support routes (если вы используете PWA, оставьте, иначе удалите)
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
