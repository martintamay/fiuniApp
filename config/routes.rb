Rails.application.routes.draw do
  scope 'api' do
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
    resources :notes do
      get '/from-date/:init_date', to: 'notes#fromDate'
      get '/of-subject/:id_subject', to: 'notes#ofSubject'
    end
  end

end
