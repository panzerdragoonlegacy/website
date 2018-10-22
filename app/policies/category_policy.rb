class CategoryPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user
        return scope if user.administrator?
      end
      scope.where publish: true
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
    permitted_attributes = attributes_except_publish
    permitted_attributes << :publish if user && user.administrator?
    permitted_attributes
  end

  private

  def attributes_except_publish
    [
      :category_type,
      :category_group_id,
      :saga_id,
      :name,
      :short_name,
      :short_name_2,
      :description
    ]
  end
end
