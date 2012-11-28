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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121128041935) do

  create_table "articles", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.text     "content"
    t.boolean  "publish"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.string   "category_type"
    t.boolean  "publish"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chapters", :force => true do |t|
    t.integer  "story_id"
    t.string   "chapter_type", :default => "regular_chapter"
    t.integer  "number",       :default => 1
    t.string   "name"
    t.string   "url"
    t.text     "content"
    t.boolean  "publish"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.text     "message"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "dragoon_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contributions", :force => true do |t|
    t.integer  "dragoon_id"
    t.integer  "contributable_id"
    t.string   "contributable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "discussions", :force => true do |t|
    t.string   "subject"
    t.string   "url"
    t.text     "message"
    t.integer  "forum_id"
    t.integer  "dragoon_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "sticky"
  end

  create_table "downloads", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.text     "information"
    t.string   "download_file_name"
    t.string   "download_content_type"
    t.integer  "download_file_size"
    t.datetime "download_updated_at"
    t.boolean  "publish"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dragoons", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "email_address"
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "perishable_token"
    t.datetime "perishable_token_expiry"
    t.string   "time_zone"
    t.string   "role",                          :default => "guest"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.date     "birthday"
    t.string   "gender"
    t.string   "country"
    t.text     "information"
    t.text     "favourite_quotations"
    t.string   "occupation"
    t.string   "interests"
    t.string   "website"
    t.string   "facebook_username"
    t.string   "twitter_username"
    t.string   "xbox_live_gamertag"
    t.string   "playstation_network_online_id"
    t.string   "wii_number"
    t.string   "steam_username"
    t.string   "windows_live_id"
    t.string   "yahoo_id"
    t.string   "aim_screenname"
    t.string   "icq_number"
    t.string   "jabber_id"
    t.string   "skype_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emoticons", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "emoticon_file_name"
    t.string   "emoticon_content_type"
    t.integer  "emoticon_file_size"
    t.datetime "emoticon_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "encyclopaedia_entries", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.text     "information"
    t.text     "content"
    t.string   "encyclopaedia_entry_picture_file_name"
    t.string   "encyclopaedia_entry_picture_content_type"
    t.integer  "encyclopaedia_entry_picture_file_size"
    t.datetime "encyclopaedia_entry_picture_updated_at"
    t.boolean  "publish"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forums", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "number",                     :default => 1
    t.string   "description"
    t.string   "forum_picture_file_name"
    t.string   "forum_picture_content_type"
    t.integer  "forum_picture_file_size"
    t.datetime "forum_picture_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "guestbook_entries", :force => true do |t|
    t.string   "name"
    t.integer  "age"
    t.string   "gender"
    t.string   "country"
    t.text     "favourite_games"
    t.text     "who_would_win"
    t.text     "comments"
    t.string   "email_address"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "illustrations", :force => true do |t|
    t.integer  "illustratable_id"
    t.string   "illustratable_type"
    t.string   "illustration_file_name"
    t.string   "illustration_content_type"
    t.integer  "illustration_file_size"
    t.datetime "illustration_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "music_tracks", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.text     "information"
    t.string   "mp3_music_track_file_name"
    t.string   "mp3_music_track_content_type"
    t.integer  "mp3_music_track_file_size"
    t.datetime "mp3_music_track_updated_at"
    t.string   "ogg_music_track_file_name"
    t.string   "ogg_music_track_content_type"
    t.integer  "ogg_music_track_file_size"
    t.datetime "ogg_music_track_updated_at"
    t.boolean  "publish"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "track_number",                 :default => 0
  end

  create_table "news_entries", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.text     "content"
    t.integer  "dragoon_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.string   "status_update"
    t.string   "short_url"
    t.boolean  "publish"
  end

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.text     "content"
    t.boolean  "publish"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pictures", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.text     "information"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.boolean  "publish"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "poems", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.text     "content"
    t.boolean  "publish"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "private_discussion_comments", :force => true do |t|
    t.text     "message"
    t.integer  "private_discussion_id"
    t.integer  "dragoon_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "private_discussion_members", :force => true do |t|
    t.integer  "private_discussion_id"
    t.integer  "dragoon_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "private_discussions", :force => true do |t|
    t.string   "subject"
    t.text     "message"
    t.integer  "dragoon_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_discussion_comments", :force => true do |t|
    t.text     "message"
    t.integer  "project_discussion_id"
    t.integer  "dragoon_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_discussions", :force => true do |t|
    t.string   "subject"
    t.text     "message"
    t.boolean  "sticky"
    t.integer  "dragoon_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_members", :force => true do |t|
    t.integer  "project_id"
    t.integer  "dragoon_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_tasks", :force => true do |t|
    t.string   "name"
    t.boolean  "completed"
    t.integer  "project_id"
    t.integer  "dragoon_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quiz_answers", :force => true do |t|
    t.integer  "quiz_question_id"
    t.text     "content"
    t.boolean  "correct_answer",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quiz_questions", :force => true do |t|
    t.integer  "quiz_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quizzes", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.boolean  "publish"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relations", :force => true do |t|
    t.integer  "encyclopaedia_entry_id"
    t.integer  "relatable_id"
    t.string   "relatable_type"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "resources", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.text     "content"
    t.boolean  "publish"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stories", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.text     "content"
    t.boolean  "publish"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
  end

  create_table "topics", :force => true do |t|
    t.string   "subject"
    t.string   "url"
    t.text     "message"
    t.integer  "dragoon_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "videos", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.text     "information"
    t.string   "mp4_video_file_name"
    t.string   "mp4_video_content_type"
    t.integer  "mp4_video_file_size"
    t.datetime "mp4_video_updated_at"
    t.string   "webm_video_file_name"
    t.string   "webm_video_content_type"
    t.integer  "webm_video_file_size"
    t.datetime "webm_video_updated_at"
    t.boolean  "publish"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "views", :force => true do |t|
    t.integer  "dragoon_id"
    t.integer  "viewable_id"
    t.string   "viewable_type"
    t.boolean  "viewed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
