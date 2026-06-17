class AddPerfilToUsuarios < ActiveRecord::Migration[6.1]
  def change
    add_column :usuarios, :descripcion, :text
    add_column :usuarios, :foto_base64, :text
  end
end
