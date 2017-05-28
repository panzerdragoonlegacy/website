class NewsEntryPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user
        return scope if user.administrator?
        return scope_user_contributes_to if user.contributor_profile
      end
      scope.where publish: true
    end

    private

    def scope_user_contributes_to
      scope.where(
        'news_entries.publish = true OR ' \
          'news_entries.contributor_profile_id = ?',
        user.contributor_profile_id
      )
    end
  end

  def show?
    if user
      return true if user.administrator?
      return true if user_authors_record?
    end
    record.publish?
  end

  def new?
    can_contribute?
  end

  def create?
    new?
  end

  def edit?
    if user
      return true if user.administrator?
      return true if user_authors_record? && !record.publish
    end
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

  def user_authors_record?
    if user.contributor_profile.present?
      if record.contributor_profile_id == user.contributor_profile_id
        return true
      end
    end
  end

  def attributes_except_publish
    [
      :contributor_profile_id,
      :name,
      :news_entry_picture,
      :content
    ]
  end
end
