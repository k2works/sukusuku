MvpSmokeTester::Application.routes.draw do
  resources :todos
  resources :manage do
    collection do
      get :finished
    end
  end

  root "pages#home"
  get "home", to: "pages#home", as: "home"
  get "inside", to: "pages#inside", as: "inside"
  get "entry", to: "pages#entry", as: "entry"
  post "entry", to: "pages#entry", as: "entry_create"

  devise_for :users

  namespace :admin do
    root "base#index"
    resources :users
  end

end
