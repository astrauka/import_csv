Dummy::Application.routes.draw do
  concern :importable do
    collection {
      get :import_form
      post :import
    }
  end

  namespace :import_via_csv, module: "import_via_csv", path: "import_via_csv" do
    resources :companies, only: [] do
      concerns :importable
    end

    resources :objects, only: [:index, :show] do
      resources :import_errors, only: [:index]
    end
  end

  root to: "import_via_csv/objects#index"
end
