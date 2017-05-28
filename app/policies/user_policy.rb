class UserPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user
        return scope if user.administrator?
      end
      []
    end
  end

  def show?
    return true if user && user.administrator?
  end
end
