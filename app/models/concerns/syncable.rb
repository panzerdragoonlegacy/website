module Syncable
  extend ActiveSupport::Concern
    
  included do
    def sync_filename_of(attachment, filename: filename)
      if self.send(attachment).present?
        if filename != self["#{attachment}_file_name"] and self.persisted?
          # Loop through each attachment style:
          self.send(attachment).options[:styles].each do |key, value|
            # Get the full path of the file from when it was last saved: 
            style_path = self.class.find(self.id).send(attachment).path(key)

            # Continue to rename the file if it exists:
            if style_path and File.exists?(style_path)
              style_directory = File.dirname style_path
              style_file = File.open style_path
              File.rename style_file, "#{style_directory}/#{filename}"
            end
          end
        end
        
        # Rename the filename in the database:
        self["#{attachment}_file_name"] = filename
      end
    end
  end  
end
