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

ActiveRecord::Schema.define(version: 20170413181049) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accesses", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "accessable_type"
    t.integer  "accessable_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["accessable_type", "accessable_id"], name: "index_accesses_on_accessable_type_and_accessable_id", using: :btree
    t.index ["user_id"], name: "index_accesses_on_user_id", using: :btree
  end

  create_table "chats", force: :cascade do |t|
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "initiator_id"
    t.integer  "recipient_id"
    t.boolean  "public_chat",  default: false
  end

  create_table "courses", force: :cascade do |t|
    t.integer  "author_id"
    t.string   "title"
    t.string   "description"
    t.boolean  "public"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "poster"
    t.string   "theme",               default: "#0275d8"
    t.boolean  "published",           default: false
    t.string   "slug"
    t.integer  "subscriptions_count", default: 0
    t.integer  "views",               default: 0
    t.integer  "tags_count",          default: 0
    t.index ["author_id"], name: "index_courses_on_author_id", using: :btree
    t.index ["slug"], name: "index_courses_on_slug", unique: true, using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "lessons", force: :cascade do |t|
    t.integer  "course_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "slug"
    t.text     "content"
    t.index ["course_id"], name: "index_lessons_on_course_id", using: :btree
    t.index ["slug"], name: "index_lessons_on_slug", unique: true, using: :btree
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "chat_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_memberships_on_chat_id", using: :btree
    t.index ["user_id"], name: "index_memberships_on_user_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.string   "text"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "chat_id"
    t.index ["chat_id"], name: "index_messages_on_chat_id", using: :btree
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "text"
    t.string   "link"
    t.boolean  "readed",     default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["user_id"], name: "index_notifications_on_user_id", using: :btree
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_posts_on_user_id", using: :btree
  end

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "website"
    t.string   "location"
    t.string   "about"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_roles_on_name", using: :btree
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "subscribeable_type"
    t.integer  "subscribeable_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["subscribeable_type", "subscribeable_id"], name: "index_subscriptions_on_subscribeable_type_and_subscribeable_id", using: :btree
    t.index ["user_id"], name: "index_subscriptions_on_user_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["taggable_type", "taggable_id"], name: "index_tags_on_taggable_type_and_taggable_id", using: :btree
  end

  create_table "unread_messages_users", id: false, force: :cascade do |t|
    t.integer "message_id"
    t.integer "user_id"
    t.index ["message_id"], name: "index_unread_messages_users_on_message_id", using: :btree
    t.index ["user_id"], name: "index_unread_messages_users_on_user_id", using: :btree
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id", using: :btree
    t.index ["user_id"], name: "index_user_roles_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.string   "avatar",            default: "/assets/images/default_avatar.jpeg"
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
    t.string   "remember_digest"
    t.string   "activation_digest"
    t.boolean  "activated"
    t.datetime "activated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "slug"
    t.index ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  end

  add_foreign_key "accesses", "users"
  add_foreign_key "memberships", "chats"
  add_foreign_key "memberships", "users"
  add_foreign_key "messages", "chats"
  add_foreign_key "messages", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
end
