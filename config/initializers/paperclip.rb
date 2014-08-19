# Spoof detection error workaround.
# More info: https://github.com/thoughtbot/paperclip/issues/1429#issuecomment-34390771

require 'paperclip/media_type_spoof_detector'
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end
