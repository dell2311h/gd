Gallerydog::Application.routes.draw do
  get "activations/create"

  # new venue manager
  resources :venue_sessions
  match 'venue/login' => "venue_sessions#new",      :as => :venue_login
  match 'venue/logout' => "venue_sessions#destroy", :as => :venue_logout
  match 'activate/:activation_code', :to => 'activations#create', :as => :activate

  # test
  match 'forgetpwd', :to => 'venues#forgetpwd', :as => :resendmail  

  
  namespace :venue_manager, :path => "venue", :module => 'venue_manager' do
    resource :info, :controller => 'info' do
      root :to => :details
      collection do
        get :details
        post :details
        
        get :images
        put :images # no idea why, but post won't work
        
        get :description
        post :description
        
        get :schedule
        post :schedule
        
        get :credentials
        post :credentials

        get :neighbourhood_autocomplete
      end
    end
    resource :listing_agent, :controller => 'ListingAgent' do
      collection do
        get :index
        post :index
      end
    end
    get :get_cities, :get_states, :get_neighbourhoods, :get_artists, :get_artist, :get_curators, :get_curator
    resources :exhibitions, :events, :events, :fairs, :press_releases
    # match "venue/images/autocomplete.json" => 'images#autocomplete'
    resources :images do
      collection do
        get :autocomplete
        post :upload
      end
    end
    resources :artists do
      collection do
        get :autocomplete
      end
    end
    resources :curators do
      collection do
        get :autocomplete
      end
    end
    
    root :to => 'exhibitions#index'
  end
  # new venue manager
  
  # user area routes
  resources :venues, :only => [:show, :new, :create] do
    member do
        get :print
        get :mail
        put :sendmail
    end
    resources :exhibitions, :only => [:show] do
      member do
        get :print
        get :mail
        put :sendmail
      end
    end
    resources :events, :only => [:show] do
      member do
        get :print
        get :mail
        put :sendmail
      end
    end
  end
  # user area routes

  namespace :backend do
      resource :stat
      resources :administrators, :listing_agents, :pages, :media_services, :users
      resources :agent_tasks do
        resources :notes
      end
      resources :cities do
        member do
          get :verify
        end
      end
      resources :neighborhoods do
        member do
          get :verify
        end
      end
      resources :fair_groupings do
        resources :fairs do
          resources :fair_events
        end
      end
      resources :region_groupings do
        collection do
         get :get_cities
         get :get_city
        end
      end
      resources :venues do
        resources :artists
        resources :events
        resources :exhibitions do
          collection do
           get :get_artists
           get :get_artist
          end
        end
      end
  end
  match '/backend' => 'backend#index', :as => :backend
  match '/backend' => 'backend#index', :as => :backend_root
  
  match '/simple_captcha/:id', :to => 'simple_captcha#show', :as => :simple_captcha
  match '/pages/:caption' => 'pages#show', :as => :page
  match '/pages/contact' => 'pages#contact', :as => :contact_page

  #  Routes for root page
  match '/region/:region_grouping_id' => 'home#index', :as => :region
  match '/neighbourhood/:neighbourhood_id' => 'home#index', :as => :neighbourhood
  match '/searchautocomplete' => 'home#searchautocomplete', :as => :searchautocomplete

  root :to => 'home#index'
  match '/:controller(/:action(/:id))'
end
