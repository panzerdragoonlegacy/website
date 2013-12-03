class Article < ActiveRecord::Base
  include Categorisable
  include Contributable
  include Illustratable
  include Relatable
  include Sluggable
  
  attr_accessible :category_id, :name, :description, :content, :publish, :dragoon_ids, :encyclopaedia_entry_ids,
    :illustrations_attributes
      
  validates :name, :presence => true, :length => { :in => 2..100 }, :uniqueness => true
  validates :description, :presence => true, :length => { :in => 2..250 }
  validates :content, :presence => true
end