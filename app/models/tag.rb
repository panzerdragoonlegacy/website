class Tag < ActiveRecord::Base
  acts_as_url :name, :sync_url => true
  
  def to_param 
    url 
  end

  attr_accessible :name, :description
  
  has_many :taggings
  
  validates :name, :presence => true, :length => { :in => 2..100 }, :uniqueness => true
  validates :description, :presence => true, :length => { :in => 2..250 }
end
