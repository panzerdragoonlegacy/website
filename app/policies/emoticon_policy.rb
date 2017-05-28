class EmoticonPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      return scope if user && user.administrator?
    end
  end
end
