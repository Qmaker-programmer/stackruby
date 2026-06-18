class PreguntaController < ApplicationController
  before_action :exigir_usuario, only: %i[ new create toggle_estrella favoritos ]
  before_action :set_preguntum, only: %i[ show edit update destroy toggle_estrella quien_dio_estrella ]

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
    # Incrementar contador de vistas
    @preguntum.incrementar_vista!
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

    # Si presionó el botón de preview
    if params[:preview]
      @preview_html = markdown_to_html(@preguntum.cuerpo_markdown)
      render :new, status: :unprocessable_entity
    elsif @preguntum.save
      redirect_to @preguntum, notice: "Pregunta creada con éxito."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pregunta/1
  def update
    # Si presionó el botón de preview
    if params[:preview]
      @preguntum.assign_attributes(preguntum_params)
      @preview_html = markdown_to_html(@preguntum.cuerpo_markdown)
      render :edit, status: :unprocessable_entity
    elsif @preguntum.update(preguntum_params)
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

  # POST /pregunta/1/toggle_estrella
  def toggle_estrella
    # No puedes dar estrella a tu propia pregunta
    if @preguntum.usuario_id == usuario_actual.id
      return redirect_to @preguntum, alert: "¡No puedes dar estrella a tus propias preguntas!"
    end

    # Buscar si ya tiene estrella
    estrella_existente = Estrella.find_by(usuario_id: usuario_actual.id, preguntum_id: @preguntum.id)

    if estrella_existente
      # Si ya tiene estrella, la quitamos
      estrella_existente.destroy
      redirect_to @preguntum, notice: "Estrella retirada."
    else
      # Si no tiene estrella, la agregamos
      Estrella.create(usuario_id: usuario_actual.id, preguntum_id: @preguntum.id)
      redirect_to @preguntum, notice: "¡Estrella agregada!"
    end
  end

  # GET /pregunta/1/quien_dio_estrella
  def quien_dio_estrella
    # Solo el autor puede ver quién le dio estrella
    unless @preguntum.usuario_id == usuario_actual&.id
      return redirect_to root_path, alert: "Acceso denegado."
    end

    @usuarios_con_estrella = @preguntum.usuarios_que_dieron_estrella
  end

  # GET /favoritos
  def favoritos
    @preguntas_favoritas = usuario_actual.preguntas_favoritas.order(created_at: :desc)
  end

  private

  def set_preguntum
    @preguntum = Preguntum.find(params[:id])
  end

  def preguntum_params
    params.require(:preguntum).permit(:titulo, :cuerpo_markdown)
  end

  def markdown_to_html(text)
    return "" if text.blank?
    require 'kramdown'

    # Normalizar tablas
    texto_normalizado = text.gsub(/\|[—–−]+\|/, '|---|')

    options = {
      input: 'GFM',
      hard_wrap: true,
      parse_block_html: true,
      parse_span_html: true
    }
    Kramdown::Document.new(texto_normalizado, options).to_html.html_safe
  end
end
