class ContributorProfilePolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      return scope if user
      scope.where(publish: true)
    end
  end

  def show?
    user || record.publish?
  end

  def new?
    user
  end

  def create?
    new?
  end

  def edit?
    return true if user && (user.administrator? || !record.publish?)
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def permitted_attributes
    permitted_attributes = contributor_profile_attributes
    permitted_attributes << :publish if user && user.administrator?
    permitted_attributes
  end

  private

  def contributor_profile_attributes
    [
      :name,
      :email_address,
      :discourse_username,
      :avatar,
      :website,
      :facebook_username,
      :twitter_username
    ]
  end
end
