module Sluggable
  extend ActiveSupport::Concern
    
  def to_param 
    url 
  end  
end