class AddPicturesToCategoriesAndTags < ActiveRecord::Migration
  def change
    add_column :categories, :category_picture_file_name, :string
    add_column :categories, :category_picture_content_type, :string
    add_column :categories, :category_picture_file_size, :integer
    add_column :categories, :category_picture_updated_at, :datetime

    add_column :tags, :tag_picture_file_name, :string
    add_column :tags, :tag_picture_content_type, :string
    add_column :tags, :tag_picture_file_size, :integer
    add_column :tags, :tag_picture_updated_at, :datetime
  end
end
