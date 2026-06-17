Rails.application.routes.draw do
  resources :pregunta do
    member do
      patch :votar_arriba
      patch :votar_abajo
      # NUEVO: Ruta GET para la vista de confirmacion antes de borrar
      get :delete, action: :confirmar_eliminacion
    end
    resources :comentarios, only: [:create] do
      member do
        patch :votar_arriba
        patch :votar_abajo
      end
    end
  end
  # Ruta para la pantalla central de resultados de usuarios
  get 'buscar_usuarios', to: 'usuarios#buscar', as: :buscar_usuarios
  # Usuarios con edicion habilitada
  resources :usuarios, only: [:show, :edit, :update] do
      member do
        get :confirmar_borrado
        delete :destruir_cuenta
      end
    end
  
  # Blog de novedades
  resources :novedades, only: [:index, :show]

  get 'entrar', to: 'sesiones#new'
  post 'registrar', to: 'sesiones#registrar'
  post 'iniciar', to: 'sesiones#iniciar'
  get 'salir', to: 'sesiones#destruir'

  root "pregunta#index"
end