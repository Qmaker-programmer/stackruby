class PreguntaController < ApplicationController
  before_action :exigir_usuario, only: %i[ new create votar_arriba votar_abajo ]
  before_action :set_preguntum, only: %i[ show edit update destroy votar_arriba votar_abajo ]

  # GET /pregunta
  def index
    # 1. TRUCO DEL SIDEBAR: Si viene el parámetro de buscar usuario
    if params[:buscar_usuario].present?
      # Buscamos el usuario ignorando mayúsculas/minúsculas (case-insensitive)
      usuario_encontrado = Usuario.where("LOWER(nombre) = ?", params[:buscar_usuario].downcase).first
      
      if usuario_encontrado
        # Si existe, lo mandamos directo a su perfil facherito
        return redirect_to usuario_path(usuario_encontrado)
      else
        # Si no existe, recargamos el index con una alerta sutil
        flash.now[:alert] = "Usuario '#{params[:buscar_usuario]}' no encontrado."
      end
    end

    # 2. Tu lógica existente para buscar preguntas (mantenemos lo que ya tenías)
    if params[:buscar].present?
      @pregunta = Preguntum.where("titulo LIKE ? OR cuerpo LIKE ?", "%#{params[:buscar]}%", "%#{params[:buscar]}%").order(created_at: :desc)
    else
      @pregunta = Preguntum.all.order(created_at: :desc)
    end
  end
  # GET /pregunta/1
  def show
  end

  # GET /pregunta/new
  def new
    @preguntum = Preguntum.new
  end

  # GET /pregunta/1/edit
  def edit
  end

  # POST /pregunta
  def create
    @preguntum = Preguntum.new(preguntum_params)
    @preguntum.usuario_id = usuario_actual.id

    if @preguntum.save
      redirect_to @preguntum, notice: "Pregunta creada con éxito."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pregunta/1
  def update
    if @preguntum.update(preguntum_params)
      redirect_to @preguntum, notice: "Pregunta actualizada."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /pregunta/1
# GET /pregunta/:id/delete
def confirmar_eliminacion
  @preguntum = Preguntum.find(params[:id])

  # FILTRO DEL BACKEND: Si no es el dueño, rebota inmediatamente
  if !usuario_actual || @preguntum.usuario_id != usuario_actual.id
    redirect_to root_path, alert: "Acceso denegado: No eres el propietario de esta pregunta."
  end
end

# DELETE /pregunta/:id
  def destroy
    @preguntum = Preguntum.find(params[:id])

    # FILTRO DEL BACKEND (Seguridad doble): Validar propiedad antes de borrar
    if !usuario_actual || @preguntum.usuario_id != usuario_actual.id
      return redirect_to root_path, alert: "Acceso denegado: No tienes permisos para realizar esta accion."
    end

    # VALIDACIÓN DE TEXTO
    if params[:confirmar_titulo] == @preguntum.titulo
      @preguntum.destroy
      redirect_to root_path, notice: "La pregunta fue eliminada correctamente."
    else
      redirect_to preguntum_path(@preguntum), alert: "Error: El titulo ingresado no coincide. No se elimino la pregunta."
    end
  end

  # PATCH /pregunta/1/votar_arriba
  def votar_arriba
    procesar_voto("arriba")
  end

  # PATCH /pregunta/1/votar_abajo
  def votar_abajo
    procesar_voto("abajo")
  end

  private

  def set_preguntum
    @preguntum = Preguntum.find(params[:id])
  end

  def preguntum_params
    params.require(:preguntum).permit(:titulo, :cuerpo)
  end

  def procesar_voto(tipo)
    # 1. Regla: No autovotos
    if @preguntum.usuario_id == usuario_actual.id
      return redirect_to root_path, alert: "¡No puedes votar tus propias preguntas!"
    end

    # 2. Regla: Máximo 10 votos POR PREGUNTA por persona
    votos_usuario_en_esta_pregunta = Voto.where(usuario_id: usuario_actual.id, preguntum_id: @preguntum.id).count

    if votos_usuario_en_esta_pregunta >= 10
      return redirect_to root_path, alert: "Ya alcanzaste el límite de 10 votos en esta pregunta."
    end

    # Si pasa las reglas, se registra el voto
    Voto.create(usuario_id: usuario_actual.id, preguntum_id: @preguntum.id, tipo: tipo)
    
    if tipo == "arriba"
      @preguntum.increment!(:votos)
    else
      @preguntum.decrement!(:votos)
    end

    redirect_to root_path, notice: "¡Voto registrado!"
  end
end
