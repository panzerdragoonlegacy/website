class Poem < ActiveRecord::Base
  acts_as_url :name, :sync_url => true
  
  def to_param 
    url 
  end
  
  has_many :contributions, :as => :contributable, :dependent => :destroy
  has_many :dragoons, :through => :contributions
  has_many :taggings, :as => :taggable, :dependent => :destroy
  has_many :tags, :through => :taggings
  
  validates :name, :presence => true, :length => { :in => 2..100 }, :uniqueness => true
  validates :description, :presence => true, :length => { :in => 2..250 }
  validates :content, :presence => true
end
