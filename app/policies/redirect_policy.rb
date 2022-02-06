class RedirectPolicy < ApplicationPolicy
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
    return true if user&.administrator?
  end

  def permitted_attributes
    %i[old_url new_url comment]
  end
end
