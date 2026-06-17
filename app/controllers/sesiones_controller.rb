class SesionesController < ApplicationController
  # Mostrar formulario de entrar / registrarse
  def new
    # Si ya inició sesión, lo mandamos al inicio para que no vuelva a entrar
    redirect_to root_path if cookies.encrypted[:usuario_id].present?
  end

  # Crear cuenta e iniciar sesión
  def registrar
    # Usamos .new en lugar de .create para poder capturar los errores si falla
    usuario = Usuario.new(nombre: params[:nombre], contrasena: params[:contrasena])
    
    if usuario.save
      cookies.encrypted[:usuario_id] = usuario.id
      redirect_to root_path, notice: "¡Cuenta creada de forma segura e inicio de sesión correcto! 💎"
    else
      # EXTRAEMOS EL ERROR REAL: Si el nombre está repetido, se lo decimos textualmente
      msg_error = usuario.errors.full_messages.to_sentence
      redirect_to entrar_path, alert: "Error al crear la cuenta: #{msg_error}"
    end
  end

  # Iniciar sesión existente
  def iniciar
    usuario = Usuario.where("LOWER(nombre) = ?", params[:nombre].to_s.downcase).first

    # Usamos el método seguro para comparar el hash encriptado
    if usuario && usuario.contrasena_valida?(params[:contrasena])
      cookies.encrypted[:usuario_id] = usuario.id
      redirect_to root_path, notice: "¡Bienvenido de vuelta, #{usuario.nombre}! 👋"
    else
      redirect_to entrar_path, alert: "Usuario o contraseña incorrectos."
    end
  end

  # Cerrar sesión
  def destruir
    cookies.delete(:usuario_id)
    redirect_to root_path, notice: "Sesión cerrada correctamente. ¡Vuelve pronto!"
  end
end