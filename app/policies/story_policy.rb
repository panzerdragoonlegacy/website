class StoryPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user
        return scope if user.administrator
        if user.contributor_profile.present?
          return scope.joins(:contributions).where("stories.publish = 't'" +
            " OR contributions.contributor_profile_id = ?", 
            user.contributor_profile_id)
        end
      end
      scope.joins(:category).where(publish: true, categories: { publish: true })
    end
  end

  def show?
    if user
      return true if user.administrator
      if user.contributor_profile.present?
        if record.contributions.first.contributor_profile_id == 
          user.contributor_profile_id
          return true
        end
      end
    end
    record.publish? and record.category.publish?
  end
end
