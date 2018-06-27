Rails.application.routes.draw do
  namespace :api do
    resources :career do
      resources :students
    end
    resources :persons
    resources :professors do
      resources :subjects
    end
    resources :students do
      resources :takens
    end
    resources :administrators
    resources :subjects do
      resources :takens
    end
    resources :takens do
      resources :notes
    end
    resources :notes
  end

end
