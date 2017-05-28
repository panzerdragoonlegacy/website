class PagePolicy < ApplicationPolicy
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

  def permitted_attributes
    permitted_attributes = page_attributes
    permitted_attributes << :publish if user && user.administrator?
    permitted_attributes
  end

  private

  def page_attributes
    [
      :name,
      :content,
      illustrations_attributes: [:id, :illustration, :_destroy]
    ]
  end
end
