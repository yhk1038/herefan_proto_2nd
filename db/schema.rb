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

ActiveRecord::Schema.define(version: 20170618173653) do

  create_table "clips", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "link_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["link_id"], name: "index_clips_on_link_id"
    t.index ["user_id"], name: "index_clips_on_user_id"
  end

  create_table "fandoms", force: :cascade do |t|
    t.string   "name"
    t.string   "profile_img"
    t.string   "background_img"
    t.boolean  "published",      default: false, null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "fd_confs", force: :cascade do |t|
    t.integer  "fandom_id"
    t.integer  "user_id"
    t.string   "fd_logo"
    t.string   "fd_bg_img"
    t.string   "fd_bg_color"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.text     "userlist",    default: "[]", null: false
    t.string   "fd_name"
    t.index ["fandom_id"], name: "index_fd_confs_on_fandom_id"
    t.index ["user_id"], name: "index_fd_confs_on_user_id"
  end

  create_table "histories", force: :cascade do |t|
    t.integer  "fandom_id"
    t.integer  "user_id"
    t.string   "title"
    t.datetime "event_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "history_id"
    t.string   "img"
    t.string   "thumb_img"
    t.index ["fandom_id"], name: "index_histories_on_fandom_id"
    t.index ["user_id"], name: "index_histories_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "link_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["link_id"], name: "index_likes_on_link_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "links", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "fandom_id"
    t.integer  "type"
    t.string   "url"
    t.string   "title"
    t.string   "description"
    t.string   "message"
    t.string   "image"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "typee",       default: 0, null: false
    t.index ["fandom_id"], name: "index_links_on_fandom_id"
    t.index ["user_id"], name: "index_links_on_user_id"
  end

  create_table "myfandoms", force: :cascade do |t|
    t.integer  "fandom_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fandom_id"], name: "index_myfandoms_on_fandom_id"
    t.index ["user_id"], name: "index_myfandoms_on_user_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer  "fandom_id"
    t.string   "category"
    t.string   "title"
    t.text     "content"
    t.datetime "event_start"
    t.datetime "event_end"
    t.string   "url"
    t.string   "class_name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["fandom_id"], name: "index_schedules_on_fandom_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",          null: false
    t.string   "encrypted_password",     default: "",          null: false
    t.boolean  "admin",                  default: false,       null: false
    t.boolean  "active",                 default: true,        null: false
    t.integer  "role",                   default: 1,           null: false
    t.integer  "point",                  default: 0,           null: false
    t.string   "nickname",               default: "Anonymous", null: false
    t.datetime "birthday"
    t.string   "name",                   default: "Anonymous", null: false
    t.string   "image"
    t.string   "img"
    t.string   "provider"
    t.string   "uid"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,           null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
<<<<<<< HEAD
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
=======
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
>>>>>>> 6158ce6ea5732d44b2955e7f6e74d5d4560aed1d
    t.integer  "fd_conf_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["fd_conf_id"], name: "index_users_on_fd_conf_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "visited_links", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "link_id"
    t.integer  "viewcount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["link_id"], name: "index_visited_links_on_link_id"
    t.index ["user_id"], name: "index_visited_links_on_user_id"
  end

  create_table "wiki_infos", force: :cascade do |t|
    t.integer  "wiki_id"
    t.string   "title"
    t.text     "content"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["wiki_id"], name: "index_wiki_infos_on_wiki_id"
  end

  create_table "wiki_pointers", force: :cascade do |t|
    t.integer  "wiki_id"
    t.integer  "sort_num"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["wiki_id"], name: "index_wiki_pointers_on_wiki_id"
  end

  create_table "wiki_posts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "wiki_id"
    t.string   "title"
    t.text     "content"
    t.string   "commit_msg"
    t.integer  "row_count"
    t.string   "url"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "wiki_pointer_id"
    t.index ["user_id"], name: "index_wiki_posts_on_user_id"
    t.index ["wiki_id"], name: "index_wiki_posts_on_wiki_id"
    t.index ["wiki_pointer_id"], name: "index_wiki_posts_on_wiki_pointer_id"
  end

  create_table "wikis", force: :cascade do |t|
    t.integer  "fandom_id"
    t.integer  "wiki_id"
    t.string   "name"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "image",      default: "/svg/facebook_send.png", null: false
    t.index ["fandom_id"], name: "index_wikis_on_fandom_id"
    t.index ["wiki_id"], name: "index_wikis_on_wiki_id"
  end

end
