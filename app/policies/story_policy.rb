class StoryPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user
        return scope if user.administrator?
        if user.contributor_profile.present?
          return scope.joins(:contributions).where(
            "stories.publish = 't'" \
              " OR contributions.contributor_profile_id = ?",
            user.contributor_profile_id
          )
        end
      end
      scope.joins(:category).where(publish: true, categories: { publish: true })
    end
  end

  def show?
    if user
      return true if user.administrator?
      return true if user_contributes_to_record?
    end
    record.publish? && record.category.publish?
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
      return true if user_contributes_to_record? && !record.publish
    end
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def permitted_attributes
    permitted_attributes = story_attributes
    permitted_attributes << :publish if user && user.administrator?
    permitted_attributes
  end

  private

  def story_attributes
    [
      :category_id,
      :name,
      :description,
      :content,
      contributor_profile_ids: [],
      encyclopaedia_entry_ids: [],
      illustrations_attributes: [:id, :illustration, :_destroy]
    ]
  end
end
