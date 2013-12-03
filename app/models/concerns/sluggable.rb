module Sluggable
  extend ActiveSupport::Concern
  
  acts_as_url :name, :sync_url => true
  
  def to_param 
    url 
  end  
end