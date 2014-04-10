class ChapterPolicy < ApplicationPolicy
  
  class Scope < Struct.new(:user, :scope)
  
    def resolve
      if user
        return scope if user.role? :administrator
        if user.role? :registered && scope.present?
          return scope if scope.first.story.contributions.first.dragoon_id == user.id
        end
      end
      scope.joins(:story).where(publish: true, stories: { publish: true })
    end

  end

  def show?
    if user
      return true if user.role? :administrator
      return true if user.role?(:registered) && record.story.contributions.first.dragoon_id == user.id
    end
    record.publish? and record.story.publish?
  end

end
