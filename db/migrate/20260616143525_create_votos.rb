class CreateVotos < ActiveRecord::Migration[6.1]
  def change
    create_table :votos do |t|
      t.integer :usuario_id
      t.integer :preguntum_id
      t.string :tipo

      t.timestamps
    end
  end
end
