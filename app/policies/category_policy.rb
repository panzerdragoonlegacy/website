class CategoryPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user
        return scope if user.administrator?
      end
      scope.where(publish: true)
    end
  end

  def show?
    if user
      return true if user.administrator?
    end
    record.publish?
  end

  def destroy?
    if user && record.send(record.category_type.pluralize).blank?
      return true if user.administrator?
    end
  end
end
