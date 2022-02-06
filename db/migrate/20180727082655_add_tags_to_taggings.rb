class AddTagsToTaggings < ActiveRecord::Migration
  def up
    Tagging.all.each do |tagging|
      if tagging.encyclopaedia_entry
        tag = Tag.where(name: tagging.encyclopaedia_entry.name).first
        tagging.tag = tag
        tagging.save
      else
        tagging.destroy!
      end
    end
  end

  def down
    Tagging.all.each do |tagging|
      tagging.tag = nil
      tagging.save
    end
  end
end
