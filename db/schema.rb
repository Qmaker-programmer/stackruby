# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2026_06_17_034342) do

  create_table "comentarios", force: :cascade do |t|
    t.text "cuerpo"
    t.integer "votos"
    t.integer "usuario_id"
    t.integer "preguntum_id"
    t.integer "comentario_padre_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "novedads", force: :cascade do |t|
    t.string "titulo"
    t.text "cuerpo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pregunta", force: :cascade do |t|
    t.string "titulo"
    t.text "cuerpo"
    t.integer "votos"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "usuario_id"
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "nombre"
    t.string "contrasena"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "descripcion"
    t.text "foto_base64"
    t.index ["nombre"], name: "index_usuarios_on_nombre", unique: true
  end

  create_table "votos", force: :cascade do |t|
    t.integer "usuario_id"
    t.integer "preguntum_id"
    t.string "tipo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
