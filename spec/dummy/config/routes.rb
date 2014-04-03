Dummy::Application.routes.draw do
  namespace :csv_imports, module: "csv_imports", path: "csv_imports" do
    resources :companies, only: [] do
      collection {
        get :import_form
        post :import
      }
    end

    resources :objects, only: [:index, :show] do
      resources :import_errors, only: [:index]
    end
  end

  root to: "csv_imports/objects#index"
end
