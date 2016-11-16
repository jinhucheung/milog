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

ActiveRecord::Schema.define(version: 20161116080011) do

  create_table "article_pictureships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "article_id", null: false
    t.integer "picture_id", null: false
    t.index ["article_id", "picture_id"], name: "index_article_pictureships_on_article_id_and_picture_id", unique: true, using: :btree
  end

  create_table "article_tagships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "article_id", null: false
    t.integer "tag_id",     null: false
    t.index ["article_id", "tag_id"], name: "index_article_tagships_on_article_id_and_tag_id", unique: true, using: :btree
  end

  create_table "articles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title",                                       null: false
    t.text     "content",       limit: 65535
    t.boolean  "posted",                      default: false
    t.integer  "view_count",                  default: 0
    t.integer  "comment_count",               default: 0
    t.integer  "user_id",                                     null: false
    t.integer  "category_id",                                 null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.text     "content_html",  limit: 65535
    t.index ["user_id", "category_id"], name: "index_articles_on_user_id_and_category_id", using: :btree
    t.index ["user_id", "created_at"], name: "index_articles_on_user_id_and_created_at", using: :btree
    t.index ["user_id"], name: "index_articles_on_user_id", using: :btree
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true, using: :btree
  end

  create_table "pictures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "picture",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "user_categoryships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id",     null: false
    t.integer "category_id", null: false
    t.index ["user_id", "category_id"], name: "index_user_categoryships_on_user_id_and_category_id", unique: true, using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "username",                              null: false
    t.string   "email",                                 null: false
    t.string   "nickname"
    t.string   "avatar"
    t.string   "bio"
    t.string   "github"
    t.string   "weibo"
    t.boolean  "admin",                 default: false, null: false
    t.string   "password_digest"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "website"
    t.string   "remember_digest"
    t.string   "activation_digest"
    t.boolean  "activated",             default: false
    t.datetime "activated_at"
    t.string   "reset_password_digest"
    t.datetime "reset_password_at"
    t.boolean  "email_public",          default: false
    t.string   "avatar_color"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

end
