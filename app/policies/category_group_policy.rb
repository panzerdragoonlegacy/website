class CategoryGroupPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def destroy?
    if user and record.categories.blank?
      return true if user.role? :administrator
    end
  end
end
