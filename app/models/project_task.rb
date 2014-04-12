class ProjectTask < ActiveRecord::Base  
  
  belongs_to :project
  belongs_to :dragoon
  has_many :contributions, :as => :contributable, :dependent => :destroy
  
  validates :name, :presence => true, :length => { :in => 2..100 }
  validates :dragoon, :presence => true
  validates :project, :presence => true
end
