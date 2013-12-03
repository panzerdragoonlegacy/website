class Article < ActiveRecord::Base
  acts_as_url :name, sync_url: true
  include Sluggable
  
  attr_accessible :category_id, :name, :description, :content, :publish, :dragoon_ids, :encyclopaedia_entry_ids,
    :illustrations_attributes
  
  belongs_to :category
  has_many :contributions, :as => :contributable, :dependent => :destroy
  has_many :dragoons, :through => :contributions
  has_many :relations, :as => :relatable, :dependent => :destroy
  has_many :encyclopaedia_entries, :through => :relations
  has_many :illustrations, :as => :illustratable, :dependent => :destroy
  accepts_nested_attributes_for :illustrations, :reject_if => lambda { |a| a[:illustration].blank? }, 
    :allow_destroy => true
    
  validates :name, :presence => true, :length => { :in => 2..100 }, :uniqueness => true
  validates :description, :presence => true, :length => { :in => 2..250 }
  validates :content, :presence => true
  validates :category, :presence => true
end