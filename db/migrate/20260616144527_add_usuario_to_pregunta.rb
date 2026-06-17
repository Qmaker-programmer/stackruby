class AddUsuarioToPregunta < ActiveRecord::Migration[6.1]
  def change
    add_column :pregunta, :usuario_id, :integer
  end
end
