Rails.application.routes.draw do
  get 'site-map', to: 'site_map#show', as: :site_map
  get 'log-in', to: 'sessions#new', as: :log_in
  get 'log-out', to: 'sessions#destroy', as: :log_out
  get 'register', to: 'dragoons#new', as: :register
  resources :dragoons do
    resources :news_entries, path: 'news-entries'
    resources :articles
    resources :downloads
    resources :links
    resources :music_tracks, path: 'music-tracks'
    resources :pictures
    resources :poems
    resources :quizzes
    resources :resources
    resources :stories
    resources :videos
  end
  resources :site_map
  resources :drafts
  resources :sessions
  resources :category_groups, path: 'category-groups'
  resources :categories
  resources :articles
  resources :pictures
  resources :downloads
  resources :videos
  resources :quizzes
  resources :news_entries, path: 'news'
  resources :stories
  resources :chapters
  resources :resources
  resources :poems
  resources :music_tracks, path: 'music'
  resources :links
  resources :encyclopaedia_entries, path: 'encyclopaedia'
  resources :emoticons
  resources :pages
  get ':id', to: 'pages#show'
  root to: "news_entries#index"
end
