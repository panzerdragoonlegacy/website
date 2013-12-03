class Project < ActiveRecord::Base
  include Sluggable
  
  attr_accessible :name, :description, :dragoon_ids

  has_many :project_discussions, :dependent => :destroy
  has_many :project_tasks, :dependent => :destroy
  has_many :project_members, :dependent => :destroy
  has_many :dragoons, :through => :project_members
  
  validates :name, :presence => true, :length => { :in => 2..100 }, :uniqueness => true
  validates :description, :presence => true, :length => { :in => 2..250 }
end
