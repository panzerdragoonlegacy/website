class Link < ActiveRecord::Base
  include Categorisable
  include Contributable
  include Relatable
    
  validates :name, :presence => true, :length => { :in => 2..100 }, :uniqueness => true
  validates :description, :presence => true, :length => { :in => 2..250 }
end