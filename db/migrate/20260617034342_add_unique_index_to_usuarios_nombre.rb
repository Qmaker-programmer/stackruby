class AddUniqueIndexToUsuariosNombre < ActiveRecord::Migration[6.1] # o la versión de tu rails
  def change
    # Le decimos a la base de datos que el campo nombre en usuarios DEBE ser único
    add_index :usuarios, :nombre, unique: true
  end
end