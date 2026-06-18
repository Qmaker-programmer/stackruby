Rails.application.routes.draw do
  resources :pregunta do
    member do
      post :toggle_estrella
      get :quien_dio_estrella
      get :delete, action: :confirmar_eliminacion
    end

    resources :comentarios, only: [:create, :update, :destroy]
  end

  # Ruta para favoritos
  get '/favoritos', to: 'pregunta#favoritos', as: 'favoritos'

  get 'buscar_usuarios', to: 'usuarios#buscar', as: :buscar_usuarios

  resources :usuarios, only: [:show, :edit, :update] do
    member do
      get :confirmar_borrado
      delete :destruir_cuenta
    end
  end

  resources :novedades, only: [:index, :show]

  get 'entrar', to: 'sesiones#new'
  post 'registrar', to: 'sesiones#registrar'
  post 'iniciar', to: 'sesiones#iniciar'
  get 'salir', to: 'sesiones#destruir'

  root "pregunta#index"
end
