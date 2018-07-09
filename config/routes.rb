Rails.application.routes.draw do
  scope 'api' do
    resources :career, only: [:index,:show,:destroy,:create,:update] do
      resources :students, only: [:index]
    end
    resources :people, only: [:index,:show,:destroy,:create,:update] do
      collection do
        #este
        put '/log_in', to: 'people#logIn'
        put '/log_out', to: 'people#logOut'
      end
    end
    resources :professors, only: [:index,:show,:destroy,:create,:update] do
      resources :subjects, only: [:index]
    end
    resources :students, only: [:index,:show,:destroy,:create,:update] do
      get '/notes/from/:init_date/to/:end_date', to: 'students#notesBetween'
      #este ya está el método
      get '/notes/from/:init_date', to: 'students#notesFrom'
      get '/takens/from/:init_date/to/:end_date', to: 'students#takensBetween'
      get '/takens/from/:init_date', to: 'students#takensFrom'
      #este ya está el método
      get '/notes', to: 'students#notes'
      get '/subjects/actives', to: 'students#activeSubjects'
      #este
      #get '/subjects', to: 'students#subjects'

      collection do
        #este
        put '/log_in', to: 'students#logIn'
        put '/log_out', to: 'students#logOut'
      end
      resources :takens, only: [:index] do
        resources :subjects, only: [:index]
      end
      resources :subjects, only: [:index]
    end
    resources :administrators, only: [:index,:show,:destroy,:create,:update]
    resources :subjects, only: [:index,:show,:destroy,:create,:update] do
      get '/takens/from/:init_date/to/:end_date', to: 'subjects#takensBetween'
      get '/takens/from/:init_date', to: 'subjects#takensFrom'
      get '/notes/from/:init_date/to/:end_date', to: 'subjects#notesBetween'
      #este
      get '/notes/from/:init_date', to: 'subjects#notesFrom'
      get '/notes', to: 'subjects#notes'
      #este
      get '/students', to: 'subjects#activeStudents'
      collection do
        get '/semester/:semester_number', to: 'subjects#fromSemester'
      end
      resources :takens, only: [:index]
    end
    resources :takens, only: [:index,:show,:destroy,:create,:update] do
      collection do
        get '/from/:init_date/to/:end_date', to: 'takens#betweenDates'
        get '/from/:init_date', to: 'takens#fromDate'
      end
      resources :notes, only: [:index]
    end
    resources :notes, only: [:index,:show,:destroy,:create,:update] do
      collection do
        #este
        post '/bulk-insert', to: 'notes#bulkInsert'
        get '/from/:init_date/to/:end_date', to: 'notes#betweenDates'
        get '/from/:init_date', to: 'notes#fromDate'
        get '/to-approve/academic', to: 'notes#toAproveAcademic'
        get '/to-approve/secretary', to: 'notes#toAproveSecretary'
        get '/to-approve', to: 'notes#toAprove'
      end
    end
  end
end
