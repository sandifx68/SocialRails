class AddSolidCableTables < ActiveRecord::Migration[8.0]
  def change
    # These are extensions that must be enabled in order to support this database
    enable_extension "pg_catalog.plpgsql"

    create_table "active_storage_attachments", force: :cascade do |t|
      t.string "name", null: false
      t.string "record_type", null: false
      t.bigint "record_id", null: false
      t.bigint "blob_id", null: false
      t.datetime "created_at", null: false
      t.index [ "blob_id" ], name: "index_active_storage_attachments_on_blob_id"
      t.index [ "record_type", "record_id", "name", "blob_id" ], name: "index_active_storage_attachments_uniqueness", unique: true
    end

    create_table "active_storage_blobs", force: :cascade do |t|
      t.string "key", null: false
      t.string "filename", null: false
      t.string "content_type"
      t.text "metadata"
      t.string "service_name", null: false
      t.bigint "byte_size", null: false
      t.string "checksum"
      t.datetime "created_at", null: false
      t.index [ "key" ], name: "index_active_storage_blobs_on_key", unique: true
    end

    create_table "active_storage_variant_records", force: :cascade do |t|
      t.bigint "blob_id", null: false
      t.string "variation_digest", null: false
      t.index [ "blob_id", "variation_digest" ], name: "index_active_storage_variant_records_uniqueness", unique: true
    end

    create_table "comments", force: :cascade do |t|
      t.string "text", null: false
      t.bigint "user_id", null: false
      t.bigint "post_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index [ "post_id" ], name: "index_comments_on_post_id"
      t.index [ "user_id" ], name: "index_comments_on_user_id"
    end

    create_table "friendships", force: :cascade do |t|
      t.bigint "user_id", null: false
      t.bigint "friend_id", null: false
      t.boolean "accepted", default: false, null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index [ "friend_id" ], name: "index_friendships_on_friend_id"
      t.index [ "user_id", "friend_id" ], name: "index_friendships_on_user_id_and_friend_id", unique: true
      t.index [ "user_id" ], name: "index_friendships_on_user_id"
    end

    create_table "likes", force: :cascade do |t|
      t.bigint "user_id", null: false
      t.bigint "post_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index [ "post_id" ], name: "index_likes_on_post_id"
      t.index [ "user_id", "post_id" ], name: "index_likes_on_user_id_and_post_id", unique: true
      t.index [ "user_id" ], name: "index_likes_on_user_id"
    end

    create_table "messages", force: :cascade do |t|
      t.string "text", null: false
      t.boolean "seen", null: false
      t.bigint "to_id", null: false
      t.bigint "from_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index [ "from_id" ], name: "index_messages_on_from_id"
      t.index [ "to_id" ], name: "index_messages_on_to_id"
    end

    create_table "posts", force: :cascade do |t|
      t.bigint "user_id", null: false
      t.text "description"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.datetime "last_edited"
      t.boolean "private", default: true, null: false
      t.index [ "user_id" ], name: "index_posts_on_user_id"
    end

    create_table "users", force: :cascade do |t|
      t.string "user_id", null: false
      t.string "display_name"
      t.text "description"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "password_digest"
      t.index [ "user_id" ], name: "index_users_on_user_id", unique: true
    end

    add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
    add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
    add_foreign_key "comments", "posts"
    add_foreign_key "comments", "users"
    add_foreign_key "friendships", "users"
    add_foreign_key "friendships", "users", column: "friend_id"
    add_foreign_key "likes", "posts"
    add_foreign_key "likes", "users"
    add_foreign_key "messages", "users", column: "from_id"
    add_foreign_key "messages", "users", column: "to_id"
    add_foreign_key "posts", "users"
  end
end
