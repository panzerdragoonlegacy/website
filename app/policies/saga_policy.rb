class SagaPolicy < ApplicationPolicy
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

  def destroy?
    return true if user && user.administrator? && record.categories.blank?
  end
end
