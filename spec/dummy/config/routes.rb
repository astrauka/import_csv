Dummy::Application.routes.draw do
  resource :home, only: [] do
    member {
      get :basic_layout
    }
  end

  root to: "homes#basic_layout"
end
