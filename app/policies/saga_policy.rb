class SagaPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user
        return scope if user.administrator?
      end
      scope.joins(:encyclopaedia_entry).where(
        encyclopaedia_entries: { publish: true }
      )
    end
  end
end
