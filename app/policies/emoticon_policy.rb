class EmoticonPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user
        return scope if user.role? :administrator
      end
    end
  end
end
