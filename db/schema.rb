# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20220315082444) do

  create_table "calificaciones", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "calificacion"
    t.integer "media_id"
    t.integer "usuario_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cat_concursos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3" do |t|
    t.string "nombre_concurso"
    t.text "descripcion_concurso"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cat_metadatos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3" do |t|
    t.string "nombre_metadato"
    t.string "descripcion"
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categorias", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3" do |t|
    t.string "nombre_categoria"
    t.integer "cat_concurso_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "direcciones", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3" do |t|
    t.string "calle"
    t.string "numero"
    t.string "interior"
    t.string "colonia"
    t.string "municipio"
    t.string "cp"
    t.string "estado"
    t.integer "usuario_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "media_metadatos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3" do |t|
    t.integer "media_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "titulo"
    t.text "descripcion"
    t.text "tecnica"
    t.text "compromiso"
    t.string "marca"
    t.string "localidad"
    t.string "otra_marca"
  end

  create_table "medias", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3" do |t|
    t.string "original_filename"
    t.string "filename"
    t.string "titulo"
    t.date "fecha_subida"
    t.string "ruta"
    t.integer "size"
    t.integer "usuario_id"
    t.integer "categoria_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "posicion"
  end

  create_table "tutores", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3" do |t|
    t.string "nombre"
    t.string "apellido_paterno"
    t.string "apellido_materno"
    t.string "telefono_contacto"
    t.string "correo"
    t.integer "usuario_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3" do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "usuario_metadatos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3" do |t|
    t.integer "metadato_id"
    t.integer "usuario_id"
    t.string "valor_metadato"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "usuarios", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3" do |t|
    t.string "nombre"
    t.string "apellido_paterno"
    t.string "apellido_materno"
    t.date "fecha_nacimiento"
    t.string "lugar_nacimiento"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "medio"
    t.integer "concurso_id", null: false
    t.string "otro_medio"
  end

end
