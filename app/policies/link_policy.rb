class LinkPolicy < ApplicationPolicy
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

  def permitted_attributes
    [
      :name,
      :url,
      :partner_site
    ]
  end
end
