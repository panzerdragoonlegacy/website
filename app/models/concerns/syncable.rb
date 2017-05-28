module Syncable
  extend ActiveSupport::Concern

  private

  def sync_file_name_of(attachment, file_name: attachment_file_name)
    if send(attachment).present?
      if file_name != self["#{attachment}_file_name"] && persisted?
        rename_each_attachment_style attachment, file_name
        rename_original_attachment_file attachment, file_name
      end

      # Rename the filename in the database:
      self["#{attachment}_file_name"] = file_name
    end
  end

  def rename_each_attachment_style(attachment, file_name)
    send(attachment).options[:styles].each do |key, _value|
      file_path = self.class.find(id).send(attachment).path(key)
      rename_file file_path, file_name
    end
  end

  def rename_original_attachment_file(attachment, file_name)
    file_path = self.class.find(id).send(attachment).path
    rename_file file_path, file_name
  end

  def rename_file(file_path, file_name)
    if file_path && File.exist?(file_path)
      file_directory = File.dirname file_path
      file = File.open file_path
      File.rename file, "#{file_directory}/#{file_name}"
    end
  end
end
