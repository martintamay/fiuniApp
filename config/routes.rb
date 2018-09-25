Rails.application.routes.draw do
  root to: 'app_react#index'
  get 'app_react/index'

  scope 'api' do
    resources :career, only: [:index,:show,:destroy,:create,:update] do
      resources :students, only: [:index]
    end
    resources :people, only: [:index,:show,:destroy,:create,:update] do
      collection do
        put '/log_in', to: 'people#logIn'
        put '/log_out', to: 'people#logOut'
        put '/relogin', to: 'people#reLogIn'
      end
    end
    resources :professors, only: [:index,:show,:destroy,:create,:update] do
      get '/subjects', to: 'professors#subjects'
    end
    resources :students, only: [:index,:show,:destroy,:create,:update] do
      get '/notes/last/:last_date/:last_time', to: 'students#lastNotes'
      get '/notes/from/:init_date/to/:end_date', to: 'students#notesBetween'
      get '/notes/from/:init_date', to: 'students#notesFrom'
      get '/takens/from/:init_date/to/:end_date', to: 'students#takensBetween'
      get '/takens/from/:init_date', to: 'students#takensFrom'
      get '/notes', to: 'students#notes'
      get '/subjects/actives', to: 'students#activeSubjects'
      get '/subjects', to: 'students#subjects'
      post '/takens', to: 'takens#bulk_inscription'

      collection do
        put '/log_in', to: 'students#logIn'
        put '/log_out', to: 'students#logOut'
      end
      resources :takens, only: [:index]
    end
    resources :administrators, only: [:index,:show,:destroy,:create,:update]
    resources :subjects, only: [:index,:show,:destroy,:create,:update] do
      get '/takens/from/:init_date/to/:end_date', to: 'subjects#takensBetween'
      get '/takens/from/:init_date', to: 'subjects#takensFrom'
      get '/notes/from/:init_date/to/:end_date', to: 'subjects#notesBetween'
      get '/notes/from/:init_date', to: 'subjects#notesFrom'
      get '/notes', to: 'subjects#notes'
      get '/notes/unfinished', to: 'subjects#unfinished_notes'
      get '/notes/taken/from-year/:year', to: 'subjects#notes_of_year'
      get '/students', to: 'subjects#activeStudents'
      get '/examinations', to: 'subjects#examinations'
      post '/takens', to: 'takens#bulk_inscription'
      put '/set-professor', to: 'subjects#set_profesor'
      collection do
        get '/uncheckeds', to: 'subjects#uncheckedNotes'
        get '/semester/:semester_number', to: 'subjects#fromSemester'
      end
      resources :takens, only: [:index]
    end
    resources :examinations, only: [:index,:show,:destroy,:create,:update] do
      collection do
        get '/uncheckeds', to: 'examinations#uncheckeds'
      end
    end
    resources :takens, only: [:index,:show,:destroy,:create,:update] do
      collection do
        get '/from/:init_date/to/:end_date', to: 'takens#betweenDates'
        get '/from/:init_date', to: 'takens#fromDate'
        post '/bulk-create', to: 'takens#bulk_inscription'
      end
      resources :notes, only: [:index]
    end
    resources :notes, only: [:index,:show,:destroy,:create,:update] do
      collection do
        post '/bulk-insert', to: 'notes#bulkInsert'
        put '/bulk-check', to: 'notes#bulkCheck'
        get '/from/:init_date/to/:end_date', to: 'notes#betweenDates'
        get '/from/:init_date', to: 'notes#fromDate'
        get '/to-approve/academic', to: 'notes#toAproveAcademic'
        get '/to-approve/secretary', to: 'notes#toAproveSecretary'
        get '/to-approve', to: 'notes#toAprove'
      end
    end
  end

  get '/:path', to: 'app_react#index'
end
