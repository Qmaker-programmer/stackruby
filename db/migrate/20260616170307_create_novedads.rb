class CreateNovedads < ActiveRecord::Migration[6.1]
  def change
    create_table :novedads do |t|
      t.string :titulo
      t.text :cuerpo

      t.timestamps
    end
  end
end
