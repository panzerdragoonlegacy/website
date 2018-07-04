Rails.application.routes.draw do
  devise_for :users, path: "", path_names: {
    sign_in: "log-in",
    sign_out: "log-out",
    sign_up: "register",
    edit: "edit-profile"
  }
  resources :users

  namespace :admin do
    get '/', to: 'home#index'
    
    resources :category_groups, path: 'category-groups'
    resources :categories
    resources :sagas
    
    resources :articles
    resources :encyclopaedia_entries, path: 'encyclopaedia-entries'
    resources :news_entries, path: 'news-entries'
    resources :pages
    resources :poems
    resources :resources
    resources :stories
    resources :chapters

    resources :downloads
    resources :links
    resources :music_tracks, path: 'music-tracks'
    resources :pictures
  end

  resources :searches
  resources :news_entries, path: 'news'
  get 'site-map', to: 'site_map#show', as: :site_map
  resources :site_map
  resources :category_groups, path: 'category-groups'
  resources :categories
  resources :encyclopaedia_entries, path: 'encyclopaedia'

  resources :contributor_profiles, path: 'contributors' do
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

  resources :articles
  resources :downloads
  resources :links
  resources :music_tracks, path: 'music'
  resources :albums
  resources :pictures
  resources :poems
  resources :quizzes
  resources :resources
  resources :stories
  resources :chapters
  resources :videos

  resources :emoticons
  resources :pages
  resources :sagas

  resources :drafts

  get ':id', to: 'pages#show'
  root to: "news_entries#index"
end
