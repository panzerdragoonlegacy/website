Rails.application.routes.draw do
  devise_for :users, path: "", path_names: {
    sign_in: "log-in",
    sign_out: "log-out",
    sign_up: "register",
    edit: "edit-profile"
  }

  namespace :admin do
    get '/', to: 'home#index'

    resources :albums
    resources :category_groups, path: 'category-groups'
    resources :categories
    resources :sagas
    resources :tags

    resources :contributor_profiles, path: 'contributor-profiles'
    resources :users

    resources :pages
    resources :articles
    resources :encyclopaedia_entries, path: 'encyclopaedia-entries'
    resources :news_entries, path: 'news-entries'
    resources :special_pages, path: 'special-pages'
    resources :poems
    resources :resources
    resources :stories
    resources :chapters

    resources :downloads
    resources :links
    resources :music_tracks, path: 'music-tracks'
    resources :pictures
    resources :quizzes
    resources :videos
  end

  resources :searches
  resources :news_entries, path: 'news'
  get 'site-map', to: 'site_map#show', as: :site_map
  resources :site_map
  resources :categories
  resources :encyclopaedia_entries, path: 'encyclopaedia'
  resources :special_pages, path: 'special-pages'
  resources :sagas
  resources :tags
  resources :contributions

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

  resources :literature
  resources :articles
  resources :downloads
  resources :links
  resources :music_tracks, path: 'music'
  resources :pictures
  resources :poems
  resources :quizzes
  resources :resources
  resources :stories
  resources :chapters
  resources :videos

  get ':id', to: 'special_pages#show'
  root to: "news_entries#index"
end
