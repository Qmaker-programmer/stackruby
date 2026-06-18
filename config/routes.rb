Rails.application.routes.draw do
  resources :pregunta do
    member do
      patch :votar_arriba
      patch :votar_abajo
      get :delete, action: :confirmar_eliminacion
    end
    # MODIFICADO: Añadido :update y :destroy al array inside 'only'
    resources :comentarios, only: [:create, :update, :destroy] do
      member do
        patch :votar_arriba
        patch :votar_abajo
      end
    end
  end

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
