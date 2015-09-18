class EncyclopaediaEntryPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user
        return scope if user.administrator
      end
      scope.joins(:category).where(publish: true, categories: { publish: true })
    end
  end

  def show?
    if user
      return true if user.administrator
    end
    record.publish? and record.category.publish?
  end
end
