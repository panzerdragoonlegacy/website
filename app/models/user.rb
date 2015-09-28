class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, 
    :trackable, :validatable, :confirmable, :lockable, :timeoutable

  belongs_to :contributor_profile

  validates :contributor_profile_id, uniqueness: true
end
