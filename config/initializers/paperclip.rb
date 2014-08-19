# Spoof detection error workaround.
# More info: https://github.com/thoughtbot/paperclip/issues/1429#issuecomment-35454746

module Paperclip
  class MediaTypeSpoofDetector
    def type_from_file_command
      begin
        Paperclip.run("file", "-b --mime :file", :file => @file.path)
      rescue Cocaine::CommandLineError
        ""
      end
    end
  end
end
