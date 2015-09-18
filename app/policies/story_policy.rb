class StoryPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user
        return scope if user.administrator
        if user.role? :registered
          return scope.joins(:category, :contributions).where(
            "(stories.publish = 't' AND categories.publish = 't') OR " +
            "contributions.dragoon_id = ?", user.id)
        end
      end
      scope.joins(:category).where(publish: true, categories: { publish: true })
    end
  end

  def show?
    if user
      return true if user.administrator
      if (user.role?(:registered) &&
        record.contributions.first.dragoon_id == user.id)
        return true
      end
    end
    record.publish? and record.category.publish?
  end
end
