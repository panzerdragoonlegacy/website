module Syncable
  extend ActiveSupport::Concern
    
  included do
    def sync_file_name_of(attachment, file_name: file_name)
      if self.send(attachment).present?
        if file_name != self["#{attachment}_file_name"] and self.persisted?
          # Rename each attachment style:
          self.send(attachment).options[:styles].each do |key, value|
            file_path = self.class.find(self.id).send(attachment).path(key)
            rename_file file_path, file_name
          end

          # Rename the original file:
          file_path = self.class.find(self.id).send(attachment).path
          rename_file file_path, file_name
        end
        
        # Rename the filename in the database:
        self["#{attachment}_file_name"] = file_name
      end
    end

    def rename_file(file_path, file_name)
      if file_path and File.exists?(file_path)
        file_directory = File.dirname file_path
        file = File.open file_path
        File.rename file, "#{file_directory}/#{file_name}"
      end
    end
  end
end
