Rails.application.routes.draw do
  devise_for :users,
             path: '',
             path_names: {
               sign_in: 'log-in',
               sign_out: 'log-out',
               edit: 'edit-profile'
             }

  namespace :admin do
    get '/', to: 'home#index'

    resources :albums
    resources :category_groups, path: 'category-groups'
    resources :categories
    resources :sagas
    resources :tags
    resources :redirects

    resources :contributor_profiles, path: 'contributor-profiles'
    resources :users

    resources :news_entries, path: 'news-entries'
    resources :pages
    resources :pictures
    resources :music_tracks, path: 'music-tracks'
    resources :videos
    resources :downloads
    resources :quizzes
  end

  namespace :redesign do
    get '/', to: 'home#show'
    resources :search, only: :index
    resources :categories, only: :show
    resources :contributions, only: :index
    resources :news_entries, only: %i[index show], path: 'news'
    resources :pictures, only: :show
    resources :literature, only: :show do
      resources :chapters, only: :show
    end
    resources :music_tracks, path: 'music', only: :show
    resources :videos, only: :show
    resources :downloads, only: :show
    resources :quizzes, only: :show

    resources :contributor_profiles, only: :show, path: 'contributors' do
      resources :news_entries, only: :index, path: 'news-entries'
      resources :pictures, only: :index
      resources :literature, only: :index
      resources :music_tracks, path: 'music-tracks', only: :index
      resources :videos, only: :index
      resources :downloads, only: :index
      resources :quizzes, only: :index
    end

    resources :tags, only: :show do
      resources :news_entries, only: :index, path: 'news-entries'
      resources :pictures, only: :index
      resources :literature, only: :index
      resources :music_tracks, path: 'music-tracks', only: :index
      resources :videos, only: :index
      resources :downloads, only: :index
      resources :quizzes, only: :index
    end

    get ':id', to: 'top_level_pages#show', as: 'top_level_page'
  end

  resources :searches, only: :index
  resources :news_entries, path: 'news'
  get 'site-map', to: 'site_map#show', as: :site_map
  resources :site_map
  resources :categories

  resources :tags do
    resources :news_entries, path: 'news-entries'
    resources :literature
    resources :pictures
    resources :music_tracks, path: 'music-tracks'
    resources :downloads
    resources :videos
    resources :quizzes
  end

  resources :contributions

  resources :contributor_profiles, path: 'contributors' do
    resources :news_entries, path: 'news-entries'
    resources :literature
    resources :pictures
    resources :music_tracks, path: 'music-tracks'
    resources :downloads
    resources :videos
    resources :quizzes
  end

  resources :news_entries, path: 'news'
  resources :literature, only: %i[index show] do
    resources :chapters, only: :show
  end
  resources :pictures
  resources :music_tracks, path: 'music'
  resources :videos
  resources :downloads
  resources :quizzes

  get ':id', to: 'top_level_page#show', as: 'top_level_page'
  root to: 'home#show'
end
