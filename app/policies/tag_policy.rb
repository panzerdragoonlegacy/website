class TagPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

  def show?
    true
  end

  def new?
    if user
      return true if user.administrator?
    end
  end

  def create?
    new?
  end

  def edit?
    if user
      return true if user.administrator?
    end
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def permitted_attributes
    [
      :name,
      :description
    ]
  end
end
