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
    return true if user && user.administrator? && record.categories.blank?
  end
end
