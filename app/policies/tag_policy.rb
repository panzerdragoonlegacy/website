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
    return true if user&.administrator?
  end

  def create?
    new?
  end

  def edit?
    return true if user&.administrator?
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def permitted_attributes
    %i[tag_picture name description information wiki_slug]
  end
end
