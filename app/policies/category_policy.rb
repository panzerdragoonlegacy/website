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

  def permitted_attributes
    permitted_attributes = [
      :category_type,
      :category_group_id,
      :name,
      :description
    ]
    if user
      permitted_attributes << :publish if user.administrator?
    end
    permitted_attributes
  end
end
