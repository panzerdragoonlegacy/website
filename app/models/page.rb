class Page < ActiveRecord::Base
  acts_as_url :name, :sync_url => true
  
  def to_param 
    url 
  end
  
  has_many :illustrations, :as => :illustratable, :dependent => :destroy
  accepts_nested_attributes_for :illustrations, :reject_if => lambda { |a| a[:illustration].blank? }, 
    :allow_destroy => true

  validates :name, :presence => true, :length => { :in => 2..100 }, :uniqueness => true
  validates :content, :presence => true
end
