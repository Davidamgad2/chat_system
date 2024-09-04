Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  resources :applications, only: [:create, :show, :index, :update], param: :token do
    resources :chats, param: :number, only: [:create, :index, :show] do
      resources :messages, param: :number, only: [:create, :index]
    end
    get "chats/:chat_number/messages/search", to: "messages#search"
  end
end
