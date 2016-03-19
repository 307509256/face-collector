# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160319092343) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "faces", force: :cascade do |t|
    t.integer  "photo_id"
    t.integer  "label_id"
    t.binary   "data"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "edited_user_id"
  end

  add_index "faces", ["edited_user_id"], name: "index_faces_on_edited_user_id", using: :btree
  add_index "faces", ["label_id"], name: "index_faces_on_label_id", using: :btree
  add_index "faces", ["photo_id"], name: "index_faces_on_photo_id", using: :btree

  create_table "inferences", force: :cascade do |t|
    t.integer  "face_id"
    t.integer  "label_id"
    t.float    "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "inferences", ["face_id"], name: "index_inferences_on_face_id", unique: true, using: :btree
  add_index "inferences", ["label_id"], name: "index_inferences_on_label_id", using: :btree
  add_index "inferences", ["score"], name: "index_inferences_on_score", using: :btree

  create_table "labels", force: :cascade do |t|
    t.string   "name"
    t.text     "tags"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "description"
    t.string   "url"
    t.integer  "index_number"
    t.string   "twitter"
  end

  add_index "labels", ["index_number"], name: "index_labels_on_index_number", unique: true, using: :btree

  create_table "photos", force: :cascade do |t|
    t.text     "source_url"
    t.text     "photo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "caption"
    t.datetime "posted_at"
    t.string   "uid"
  end

  add_index "photos", ["uid"], name: "index_photos_on_uid", unique: true, using: :btree

  create_table "queries", force: :cascade do |t|
    t.text     "text"
    t.datetime "executed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "screen_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "faces", "labels"
  add_foreign_key "faces", "photos"
  add_foreign_key "inferences", "faces"
  add_foreign_key "inferences", "labels"
end
