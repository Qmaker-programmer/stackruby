class ComentariosController < ApplicationController
  before_action :exigir_usuario

  def create
    @preguntum = Preguntum.find(params[:preguntum_id])
    @comentario = @preguntum.comentarios.new(cuerpo: params[:cuerpo])
    @comentario.usuario_id = usuario_actual.id
    @comentario.comentario_padre_id = params[:comentario_padre_id] if params[:comentario_padre_id].present?

    if @comentario.save
      redirect_to @preguntum, notice: "¡Comentario publicado!"
    else
      redirect_to @preguntum, alert: "No se pudo publicar el comentario."
    end
  end

  # Acción para procesar la actualización del comentario
  def update
    @comentario = Comentario.find(params[:id])

    # Seguridad: Solo el autor real puede editar su propio comentario no-fantasma
    if usuario_actual && @comentario.usuario_id == usuario_actual.id && !@comentario.fantasma?
      if @comentario.update(cuerpo: params[:cuerpo])
        redirect_to @comentario.preguntum, notice: "¡Comentario actualizado!"
      else
        redirect_to @comentario.preguntum, alert: "Error al actualizar el comentario."
      end
    else
      redirect_to @comentario.preguntum, alert: "Acceso denegado."
    end
  end

  def destroy
    @comentario = Comentario.find(params[:id])

    if usuario_actual && @comentario.usuario_id == usuario_actual.id
      # Al ejecutar este método, se disparan los descuentos de votos y la poda de fantasmas de forma secuencial
      @comentario.eliminar_con_poda!
      redirect_to preguntum_path(@comentario.preguntum), notice: "El comentario y sus puntuaciones asociadas han sido procesados."
    else
      redirect_to preguntum_path(@comentario.preguntum), alert: "Acceso denegado."
    end
  end


  # Los comentarios ya no tienen sistema de votos
end
