class ApplicationController < ActionController::Base
  helper_method :usuario_actual

  def usuario_actual
    @usuario_actual ||= Usuario.find_by(id: cookies.encrypted[:usuario_id]) if cookies.encrypted[:usuario_id]
  end

  def exigir_usuario
    redirect_to entrar_path, alert: "Debes iniciar sesión para hacer esto." unless usuario_actual
  end
end
