class ComentariosController < ApplicationController
  before_action :exigir_usuario

  def create
    @preguntum = Preguntum.find(params[:preguntum_id])
    # Creamos el comentario asociado a la pregunta y al usuario actual
    @comentario = @preguntum.comentarios.new(cuerpo: params[:cuerpo])
    @comentario.usuario_id = usuario_actual.id
    # Si viene de una respuesta, le asignamos su padre
    @comentario.comentario_padre_id = params[:comentario_padre_id] if params[:comentario_padre_id].present?

    if @comentario.save
      redirect_to @preguntum, notice: "¡Comentario publicado!"
    else
      redirect_to @preguntum, alert: "No se pudo publicar el comentario."
    end
  end

  def votar_arriba
    @comentario = Comentario.find(params[:id])
    @comentario.increment!(:votos)
    redirect_to @comentario.preguntum
  end

  def votar_abajo
    @comentario = Comentario.find(params[:id])
    @comentario.decrement!(:votos)
    redirect_to @comentario.preguntum
  end
end
