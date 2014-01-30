MovieScraper::Application.routes.draw do
  root 'movies#index'

  resources :movies do
    resources :cinemas do
      resources :contacts
      resources :show_times
    end
  end
end
