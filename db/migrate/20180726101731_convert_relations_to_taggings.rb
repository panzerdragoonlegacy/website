class ConvertRelationsToTaggings < ActiveRecord::Migration
  def up
    rename_table :relations, :taggings
    add_column :taggings, :tag_id, :integer
    rename_column :taggings, :relatable_id, :taggable_id
    rename_column :taggings, :relatable_type, :taggable_type

    taggings = Tagging.all
    taggings.each do |tagging|
      tag = Tag.where(name: tagging.encyclopaedia_entry.name).first
      tagging.tag_id = tag.id
      tagging.save
    end
  end

  def down
    rename_column :taggings, :taggable_type, :relatable_type
    rename_column :taggings, :taggable_id, :relatable_id
    remove_column :taggings, :tag_id
    rename_table :taggings, :relations
  end
end
