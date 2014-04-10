class QuizPolicy < ApplicationPolicy
  
  class Scope < Struct.new(:user, :scope)
  
    def resolve
      if user
        return scope if user.role? :administrator
        if user.role? :registered
          return scope.joins(:contributions).where("quizzes.publish = 't' OR contributions.dragoon_id = ?", user.id)
        end
      end
      scope.where(publish: true)
    end

  end

  def show?
    if user
      return true if user.role? :administrator
      return true if user.role?(:registered) && record.contributions.first.dragoon_id == user.id
    end
    record.publish?
  end

end
