class ChapterPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user
        return scope if user.administrator
        if user.role? :registered && scope.present?
          if scope.first.story.contributions.first.dragoon_id == user.id
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
      if (user.role?(:registered) &&
        record.story.contributions.first.dragoon_id == user.id)
        return true
      end
    end
    record.publish? and record.story.publish?
  end
end
