class AlbumPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user
        return scope if user.administrator?
        if user.contributor_profile.present?
          return scope.joins(:category, :contributions).where(
            "categories.publish = 't' OR " +
            "contributions.contributor_profile_id = ?",
            user.contributor_profile_id
          )
        end
      end
      scope.joins(:category).where(categories: { publish: true })
    end
  end

  def show?
    false # An album is never shown directly.
  end

  def new?
    if user
      return true if user.administrator? || user.contributor_profile.present?
    end
  end

  def create?
    new?
  end

  def edit?
    if user
      return true if user.administrator?
      if user.contributor_profile.present?
        if record.contributions.where(
          contributor_profile_id: user.contributor_profile_id
        ).count > 0
          return true
        end
      end
    end
  end

  def update?
    edit?
  end

  def destroy?
    if record.pictures.blank?
      edit?
    end
  end

  def permitted_attributes
    permitted_attributes = [
      :category_id,
      :name,
      :description,
      contributor_profile_ids: []
    ]
    permitted_attributes
  end
end
