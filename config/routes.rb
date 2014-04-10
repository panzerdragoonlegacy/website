TheWillOfTheAncients::Application.routes.draw do

  get "search/index"

  get "log-in" => "sessions#new", :as => :log_in  
  get "log-out" => "sessions#destroy", :as => :log_out
  get "register" => "dragoons#new", :as => :register
  resources :dragoons do
    resources :news_entries, :path => 'news-entries'
    resources :articles
    resources :downloads
    resources :links
    resources :music_tracks, :path => 'music-tracks'
    resources :pictures
    resources :poems
    resources :quizzes
    resources :resources
    resources :stories
    resources :videos
  end
  resources :sessions
  resources :password_resets, :path => 'password-resets'
  resources :categories
  resources :articles
  resources :pictures
  resources :downloads
  resources :videos
  resources :quizzes
  resources :news_entries, :path => 'news'
  resources :stories
  resources :chapters
  resources :resources
  resources :poems
  resources :music_tracks, :path => 'music'
  resources :links
  resources :encyclopaedia_entries, :path => 'encyclopaedia'
  resources :emoticons
  resources :pages
  match '/:id' => 'pages#show'
  root :to => "news_entries#index"

end