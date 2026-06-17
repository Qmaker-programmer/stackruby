class NovedadesController < ApplicationController
  def index
    @novedades = Novedad.order(created_at: :desc)
  end

  def show
    @novedad = Novedad.find(params[:id])
  end
end
