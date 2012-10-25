class CommunityController < ApplicationController  
  def index
    @discussion_categories = Category.accessible_by(current_ability).where(:category_type => :discussion).order('name desc')
    @projects = Project.accessible_by(current_ability).order('name')
  end
end
