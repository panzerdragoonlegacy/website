class ContributorProfilePolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      return scope if user
      scope.where publish: true
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
    permitted_attributes = attributes_except_publish
    permitted_attributes << :publish if user && user.administrator?
    permitted_attributes
  end

  private

  def attributes_except_publish
    %i[
      name
      description
      information
      roles
      email_address
      discourse_username
      discord_user_id
      fandom_username
      avatar
      website_name
      website_url
      bluesky_username
      fediverse_username
      fediverse_url
      facebook_username
      twitter_username
      instagram_username
      deviantart_username
    ]
  end
end
