class ChapterPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user
        return scope if user.administrator
        if user.contributor_profile.present? && scope.present?
          if scope.first.story.contributions.first.contributor_profile_id == 
            user.contributor_profile_id
            return scope
          end
        end
      end
      scope.joins(:story).where(publish: true, stories: { publish: true })
    end
  end

  def show?
    if user
      return true if user.administrator
      if user.contributor_profile.present?
        if record.story.contributions.first.contributor_profile_id == 
          user.contributor_profile_id
          return true
        end
      end
    end
    record.publish? and record.story.publish?
  end
end
