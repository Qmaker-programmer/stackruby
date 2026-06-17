class UsuariosController < ApplicationController
  before_action :exigir_usuario, only: [:edit, :update]

  def show
    @usuario = Usuario.find(params[:id])
    @pregunta = Preguntum.where(usuario_id: @usuario.id).order(created_at: :desc)
    @total_preguntas = @pregunta.count
    @total_votos_recibidos = @pregunta.sum(:votos)
    @votos_emitidos = Voto.where(usuario_id: @usuario.id).count
  end
  # GET /buscar_usuarios
  def buscar
    # Tomamos el término enviado por el formulario
    @termino = params[:termino].to_s.strip

    if @termino.present?
      # Busqueda aproximada: busca cualquier nombre que CONTENGA el término
      # El % antes y después significa "cualquier cosa antes o después"
      @usuarios = Usuario.where("LOWER(nombre) LIKE ?", "%#{@termino.downcase}%").order(nombre: :asc)
    else
      @usuarios = Usuario.none
    end
  end

  # GET /usuarios/:id/confirmar_borrado
  def confirmar_borrado
    @usuario = Usuario.find(params[:id])

    # CONTROL DE BACKEND: Solo puedes borrar tu propia cuenta
    if !usuario_actual || @usuario.id != usuario_actual.id
      return redirect_to root_path, alert: "Acceso denegado."
    end

    # Generamos los datos aleatorios del desafio
    @veces = rand(2..6) # Rango de repeticiones (editable, ej: 2 a 6 veces)
    @num1 = rand(0..100)
    @num2 = rand(0..100)

    # Calculamos las respuestas correctas esperadas en el servidor
    nombre_repetido = @usuario.nombre * @veces
    suma_correcta = @num1 + @num2
    eliminar_repetido = "ELIMINAR" * @veces

    # Guardamos las respuestas en la sesion del servidor (nadie las puede ver ni alterar)
    session[:desafio_borrado] = {
      nombre: nombre_repetido,
      suma: suma_correcta.to_s,
      palabra: eliminar_repetido
    }
  end

  # DELETE /usuarios/:id/destruir_cuenta
  def destruir_cuenta
    @usuario = Usuario.find(params[:id])

    # CONTROL DE BACKEND: Validar propiedad
    if !usuario_actual || @usuario.id != usuario_actual.id
      return redirect_to root_path, alert: "Acceso denegado."
    end

    # Extraemos las soluciones almacenadas en la sesion
    soluciones = session[:desafio_borrado]

    if soluciones.nil?
      return redirect_to edit_usuario_path(@usuario), alert: "El desafio expiro. Intente nuevamente."
    end

    # Validamos cada una de las entradas enviadas por el formulario plano
    check_nombre  = params[:verificacion_nombre] == soluciones["nombre"]
    check_suma    = params[:verificacion_suma].to_s.strip == soluciones["suma"]
    check_palabra = params[:verificacion_palabra] == soluciones["palabra"]

    if check_nombre && check_suma && check_palabra
      # Desafio superado con exito total: Limpiamos sesion y destruimos
      session.delete(:desafio_borrado)
      cookies.delete(:usuario_id) # Se cierra su sesion
      
      @usuario.destroy
      redirect_to root_path, notice: "Su cuenta ha sido eliminada permanentemente. Lamentamos verle partir."
    else
      # Si algo fallo, limpiamos el token viejo y lo obligamos a reintentar con nuevos numeros
      session.delete(:desafio_borrado)
      redirect_to confirmar_borrado_usuario_path(@usuario), alert: "Error: No supero las pruebas de verificacion exacta. Intente de nuevo."
    end
  end

  def edit
    @usuario = usuario_actual
    @foto_previa_base64 = nil
  end

  def update
    @usuario = usuario_actual
    
    # Procesar foto Base64 (tu lógica facherina existente)
    if params[:usuario][:foto].present?
      archivo = params[:usuario][:foto].tempfile
      base64_data = Base64.strict_encode64(archivo.read)
      @usuario.foto_base64 = "data:#{params[:usuario][:foto].content_type};base64,#{base64_data}"
    end

    # Intentamos asignar los nuevos datos
    @usuario.nombre = params[:usuario][:nombre]
    @usuario.descripcion = params[:usuario][:descripcion]

    # Si pasa las validaciones (nombre único), guarda y redirige
    if @usuario.save
      # OJO: Si tu sistema de cookies de sesión usa el NOMBRE del usuario para trackearlo,
      # actualiza la cookie aquí para que no pierda la sesión activa:
      cookies.encrypted[:usuario_id] = @usuario.id # RECOMENDADO: Guardar el ID, nunca el nombre mero
      
      redirect_to usuario_path(@usuario), notice: "¡Perfil facherito actualizado con éxito!"
    else
      # Si el nombre está repetido, Rails mete el error en @usuario.errors
      flash.now[:alert] = "No se pudo actualizar: El nombre de usuario ya está en uso por alguien más."
      render :edit, status: :unprocessable_entity
    end
  end
end