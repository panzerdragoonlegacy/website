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

ActiveRecord::Schema[7.0].define(version: 2023_11_11_055724) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "category_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "publish", default: false
    t.text "information"
    t.datetime "published_at", precision: nil
    t.string "source_url"
    t.string "instagram_post_id"
    t.string "slug"
    t.index ["category_id"], name: "index_albums_on_category_id"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "description", limit: 255
    t.string "category_type", limit: 255
    t.boolean "publish", default: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "published_at", precision: nil
    t.string "category_picture_file_name"
    t.string "category_picture_content_type"
    t.integer "category_picture_file_size"
    t.datetime "category_picture_updated_at", precision: nil
    t.string "slug"
    t.boolean "list_view", default: false
  end

  create_table "categorisations", force: :cascade do |t|
    t.bigint "parent_id"
    t.bigint "subcategory_id"
    t.integer "sequence_number", default: 1
    t.string "short_name_in_parent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_categorisations_on_parent_id"
    t.index ["subcategory_id"], name: "index_categorisations_on_subcategory_id"
  end

  create_table "contributions", id: :serial, force: :cascade do |t|
    t.integer "contributor_profile_id"
    t.integer "contributable_id"
    t.string "contributable_type", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "contributor_profiles", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "email_address", limit: 255
    t.string "avatar_file_name", limit: 255
    t.string "avatar_content_type", limit: 255
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at", precision: nil
    t.string "website_url", limit: 255
    t.string "facebook_username", limit: 255
    t.string "twitter_username", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "discourse_username"
    t.boolean "publish", default: false
    t.string "description"
    t.string "website_name"
    t.datetime "published_at", precision: nil
    t.string "instagram_username"
    t.string "deviantart_username"
    t.string "discord_user_id"
    t.string "fandom_username"
    t.string "slug"
    t.string "roles"
    t.text "information"
    t.string "fediverse_username"
    t.string "fediverse_url"
  end

  create_table "downloads", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "description", limit: 255
    t.text "information"
    t.string "download_file_name", limit: 255
    t.string "download_content_type", limit: 255
    t.integer "download_file_size"
    t.datetime "download_updated_at", precision: nil
    t.boolean "publish", default: false
    t.integer "category_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "download_picture_file_name"
    t.string "download_picture_content_type"
    t.integer "download_picture_file_size"
    t.datetime "download_picture_updated_at", precision: nil
    t.datetime "published_at", precision: nil
    t.string "slug"
  end

  create_table "illustrations", id: :serial, force: :cascade do |t|
    t.integer "page_id"
    t.string "illustration_file_name", limit: 255
    t.string "illustration_content_type", limit: 255
    t.integer "illustration_file_size"
    t.datetime "illustration_updated_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "music_tracks", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "description", limit: 255
    t.text "information"
    t.string "mp3_music_track_file_name", limit: 255
    t.string "mp3_music_track_content_type", limit: 255
    t.integer "mp3_music_track_file_size"
    t.datetime "mp3_music_track_updated_at", precision: nil
    t.boolean "publish", default: false
    t.integer "category_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "track_number", default: 0
    t.string "flac_music_track_file_name", limit: 255
    t.string "flac_music_track_content_type", limit: 255
    t.integer "flac_music_track_file_size"
    t.datetime "flac_music_track_updated_at", precision: nil
    t.string "music_track_picture_file_name"
    t.string "music_track_picture_content_type"
    t.integer "music_track_picture_file_size"
    t.datetime "music_track_picture_updated_at", precision: nil
    t.datetime "published_at", precision: nil
    t.string "slug"
  end

  create_table "news_entries", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "content"
    t.integer "contributor_profile_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "published_at", precision: nil
    t.boolean "publish", default: false
    t.string "news_entry_picture_file_name"
    t.string "news_entry_picture_content_type"
    t.integer "news_entry_picture_file_size"
    t.datetime "news_entry_picture_updated_at", precision: nil
    t.string "summary"
    t.string "slug"
    t.string "alternative_slug"
  end

  create_table "pages", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.text "information"
    t.text "content"
    t.boolean "publish"
    t.string "page_type"
    t.integer "parent_page_id"
    t.integer "sequence_number"
    t.integer "category_id"
    t.string "page_picture_file_name"
    t.string "page_picture_content_type"
    t.integer "page_picture_file_size"
    t.datetime "page_picture_updated_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "published_at", precision: nil
    t.string "slug"
  end

  create_table "pictures", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "description", limit: 255
    t.text "information"
    t.string "picture_file_name", limit: 255
    t.string "picture_content_type", limit: 255
    t.integer "picture_file_size"
    t.datetime "picture_updated_at", precision: nil
    t.boolean "publish", default: false
    t.integer "category_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "id_of_picture_to_replace"
    t.integer "album_id"
    t.string "source_url"
    t.datetime "published_at", precision: nil
    t.boolean "full_size_link", default: true
    t.integer "sequence_number", default: 1
    t.boolean "controversial_content", default: false
    t.string "instagram_post_id"
    t.string "slug"
  end

  create_table "redirects", id: :serial, force: :cascade do |t|
    t.string "old_url"
    t.string "new_url"
    t.text "comment"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "taggable_id"
    t.string "taggable_type", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "tag_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "tag_picture_file_name"
    t.string "tag_picture_content_type"
    t.integer "tag_picture_file_size"
    t.datetime "tag_picture_updated_at", precision: nil
    t.text "information"
    t.string "wiki_slug"
    t.string "slug"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "administrator", default: false
    t.integer "contributor_profile_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at", precision: nil
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "videos", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "description", limit: 255
    t.text "information"
    t.string "mp4_video_file_name", limit: 255
    t.string "mp4_video_content_type", limit: 255
    t.integer "mp4_video_file_size"
    t.datetime "mp4_video_updated_at", precision: nil
    t.boolean "publish", default: false
    t.integer "category_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "youtube_video_id", limit: 255
    t.string "video_picture_file_name"
    t.string "video_picture_content_type"
    t.integer "video_picture_file_size"
    t.datetime "video_picture_updated_at", precision: nil
    t.datetime "published_at", precision: nil
    t.string "source_url"
    t.integer "album_id"
    t.integer "sequence_number", default: 1
    t.string "slug"
  end

  add_foreign_key "albums", "categories"
  add_foreign_key "categorisations", "categories", column: "parent_id"
  add_foreign_key "categorisations", "categories", column: "subcategory_id"
end
