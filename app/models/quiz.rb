class Quiz < ActiveRecord::Base
  acts_as_url :name, :sync_url => true
  
  def to_param 
    url 
  end
  
  has_many :contributions, :as => :contributable, :dependent => :destroy
  has_many :dragoons, :through => :contributions
  has_many :relations, :as => :relatable, :dependent => :destroy
  has_many :encyclopaedia_entries, :through => :relations
  has_many :quiz_questions, :dependent => :destroy  
  accepts_nested_attributes_for :quiz_questions, 
    :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true

  validates :name, :presence => true, :length => { :in => 2..100 }, :uniqueness => true
  validates :description, :presence => true, :length => { :in => 2..250 }
end
