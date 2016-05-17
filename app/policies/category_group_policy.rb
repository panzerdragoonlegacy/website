class CategoryGroupPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def show?
    true
  end

  def destroy?
    if user && record.categories.blank?
      return true if user.administrator?
    end
  end
end
