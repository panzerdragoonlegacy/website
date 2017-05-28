class SagaPolicy < ApplicationPolicy
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
      scope.joins(:encyclopaedia_entry).where(
        encyclopaedia_entries: { publish: true }
      )
    end
  end
end
