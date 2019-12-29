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
    if user && user.administrator?
      if record.category_type == :literature.to_s
        return true if record.pages.blank?
      else
        return true if record.send(record.category_type.pluralize).blank?
      end
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
      :category_picture,
      :category_type,
      :category_group_id,
      :saga_id,
      :name,
      :short_name_for_saga,
      :short_name_for_media_type,
      :description
    ]
  end
end
