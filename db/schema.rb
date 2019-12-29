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

ActiveRecord::Schema.define(version: 20191229010808) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.integer  "category_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "publish",      default: false
    t.text     "information"
    t.datetime "published_at"
    t.string   "source_url"
  end

  add_index "albums", ["category_id"], name: "index_albums_on_category_id", using: :btree

  create_table "articles", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "url",          limit: 255
    t.string   "description",  limit: 255
    t.text     "content"
    t.boolean  "publish",                  default: false
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",                          limit: 255
    t.string   "url",                           limit: 255
    t.string   "description",                   limit: 255
    t.string   "category_type",                 limit: 255
    t.boolean  "publish",                                   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_group_id"
    t.integer  "saga_id"
    t.string   "short_name_for_saga"
    t.string   "short_name_for_media_type"
    t.datetime "published_at"
    t.string   "category_picture_file_name"
    t.string   "category_picture_content_type"
    t.integer  "category_picture_file_size"
    t.datetime "category_picture_updated_at"
  end

  add_index "categories", ["saga_id"], name: "index_categories_on_saga_id", using: :btree

  create_table "category_groups", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "category_group_type"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "chapters", force: :cascade do |t|
    t.integer  "story_id"
    t.string   "chapter_type", limit: 255, default: "regular_chapter"
    t.integer  "number",                   default: 1
    t.string   "name",         limit: 255
    t.string   "url",          limit: 255
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contributions", force: :cascade do |t|
    t.integer  "contributor_profile_id"
    t.integer  "contributable_id"
    t.string   "contributable_type",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contributor_profiles", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.string   "url",                 limit: 255
    t.string   "email_address",       limit: 255
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "website_url",         limit: 255
    t.string   "facebook_username",   limit: 255
    t.string   "twitter_username",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "discourse_username"
    t.boolean  "publish",                         default: false
    t.string   "description"
    t.string   "website_name"
    t.datetime "published_at"
  end

  create_table "downloads", force: :cascade do |t|
    t.string   "name",                          limit: 255
    t.string   "url",                           limit: 255
    t.string   "description",                   limit: 255
    t.text     "information"
    t.string   "download_file_name",            limit: 255
    t.string   "download_content_type",         limit: 255
    t.integer  "download_file_size"
    t.datetime "download_updated_at"
    t.boolean  "publish",                                   default: false
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "download_picture_file_name"
    t.string   "download_picture_content_type"
    t.integer  "download_picture_file_size"
    t.datetime "download_picture_updated_at"
    t.datetime "published_at"
  end

  create_table "encyclopaedia_entries", force: :cascade do |t|
    t.string   "name",                                     limit: 255
    t.string   "url",                                      limit: 255
    t.text     "information"
    t.text     "content"
    t.string   "encyclopaedia_entry_picture_file_name",    limit: 255
    t.string   "encyclopaedia_entry_picture_content_type", limit: 255
    t.integer  "encyclopaedia_entry_picture_file_size"
    t.datetime "encyclopaedia_entry_picture_updated_at"
    t.boolean  "publish",                                              default: false
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
  end

  create_table "illustrations", force: :cascade do |t|
    t.integer  "illustratable_id"
    t.string   "illustratable_type",        limit: 255
    t.string   "illustration_file_name",    limit: 255
    t.string   "illustration_content_type", limit: 255
    t.integer  "illustration_file_size"
    t.datetime "illustration_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "url",          limit: 255
    t.string   "description",  limit: 255
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "partner_site",             default: false
  end

  create_table "music_tracks", force: :cascade do |t|
    t.string   "name",                             limit: 255
    t.string   "url",                              limit: 255
    t.string   "description",                      limit: 255
    t.text     "information"
    t.string   "mp3_music_track_file_name",        limit: 255
    t.string   "mp3_music_track_content_type",     limit: 255
    t.integer  "mp3_music_track_file_size"
    t.datetime "mp3_music_track_updated_at"
    t.boolean  "publish",                                      default: false
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "track_number",                                 default: 0
    t.string   "flac_music_track_file_name",       limit: 255
    t.string   "flac_music_track_content_type",    limit: 255
    t.integer  "flac_music_track_file_size"
    t.datetime "flac_music_track_updated_at"
    t.string   "music_track_picture_file_name"
    t.string   "music_track_picture_content_type"
    t.integer  "music_track_picture_file_size"
    t.datetime "music_track_picture_updated_at"
    t.datetime "published_at"
  end

  create_table "news_entries", force: :cascade do |t|
    t.string   "name",                            limit: 255
    t.string   "url",                             limit: 255
    t.text     "content"
    t.integer  "contributor_profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.boolean  "publish",                                     default: false
    t.string   "news_entry_picture_file_name"
    t.string   "news_entry_picture_content_type"
    t.integer  "news_entry_picture_file_size"
    t.datetime "news_entry_picture_updated_at"
    t.integer  "category_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.string   "name",                     limit: 255
    t.string   "url",                      limit: 255
    t.string   "description",              limit: 255
    t.text     "information"
    t.string   "picture_file_name",        limit: 255
    t.string   "picture_content_type",     limit: 255
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.boolean  "publish",                              default: false
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "id_of_picture_to_replace"
    t.integer  "album_id"
    t.string   "source_url"
    t.datetime "published_at"
  end

  create_table "poems", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "url",          limit: 255
    t.string   "description",  limit: 255
    t.text     "content"
    t.boolean  "publish",                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
  end

  create_table "quiz_answers", force: :cascade do |t|
    t.integer  "quiz_question_id"
    t.text     "content"
    t.boolean  "correct_answer",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quiz_questions", force: :cascade do |t|
    t.integer  "quiz_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quizzes", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "url",          limit: 255
    t.string   "description",  limit: 255
    t.boolean  "publish",                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
  end

  create_table "resources", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "url",          limit: 255
    t.text     "content"
    t.boolean  "publish",                  default: false
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
  end

  create_table "sagas", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "sequence_number",        default: 1
    t.integer  "encyclopaedia_entry_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "sagas", ["encyclopaedia_entry_id"], name: "index_sagas_on_encyclopaedia_entry_id", using: :btree

  create_table "special_pages", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "url",          limit: 255
    t.text     "content"
    t.boolean  "publish",                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
  end

  create_table "stories", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "url",          limit: 255
    t.string   "description",  limit: 255
    t.text     "content"
    t.boolean  "publish",                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.datetime "published_at"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "taggable_id"
    t.string   "taggable_type", limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tag_picture_file_name"
    t.string   "tag_picture_content_type"
    t.integer  "tag_picture_file_size"
    t.datetime "tag_picture_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "administrator",          default: false
    t.integer  "contributor_profile_id"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "videos", force: :cascade do |t|
    t.string   "name",                       limit: 255
    t.string   "url",                        limit: 255
    t.string   "description",                limit: 255
    t.text     "information"
    t.string   "mp4_video_file_name",        limit: 255
    t.string   "mp4_video_content_type",     limit: 255
    t.integer  "mp4_video_file_size"
    t.datetime "mp4_video_updated_at"
    t.boolean  "publish",                                default: false
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "youtube_video_id",           limit: 255
    t.string   "video_picture_file_name"
    t.string   "video_picture_content_type"
    t.integer  "video_picture_file_size"
    t.datetime "video_picture_updated_at"
    t.datetime "published_at"
  end

  add_foreign_key "albums", "categories"
  add_foreign_key "sagas", "encyclopaedia_entries"
end
