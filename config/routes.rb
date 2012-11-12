TheWillOfTheAncients::Application.routes.draw do

  get "log-in" => "sessions#new", :as => :log_in  
  get "log-out" => "sessions#destroy", :as => :log_out
  get "register" => "dragoons#new", :as => :register
  get "sign-guestbook" => "guestbook_entries#new", :as => :sign_guestbook
  get "community" => "community#index", :as => :community
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
    resources :discussions
    resources :comments
  end
  resources :sessions
  resources :password_resets, :path => 'password-resets'
  resources :categories
  resources :forums
  resources :discussions
  resources :articles
  resources :comments
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
  resources :guestbook_entries, :path => 'guestbook'
  resources :emoticons
  resources :projects do
    resources :project_discussions, :path => 'discussions' do
      resources :project_discussion_comments, :path => 'comments'
    end
    resources :project_tasks, :path => 'tasks'
    resources :project_members, :path => 'members'
  end
  resources :private_discussions, :path => 'private-discussions' do
    resources :private_discussion_comments, :path => 'comments'
  end
  resources :pages
  match '/:id' => 'pages#show'
  root :to => "news_entries#index"

end