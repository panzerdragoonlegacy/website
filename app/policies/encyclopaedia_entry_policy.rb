class EncyclopaediaEntryPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user
        return scope if user.administrator?
        if user.contributor_profile.present?
          return scope.joins(:category, :contributions).where(
            "(encyclopaedia_entries.publish = 't' AND categories.publish = " \
              "'t') OR contributions.contributor_profile_id = ?",
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
    permitted_attributes = encyclopaedia_entry_attributes
    permitted_attributes << :publish if user && user.administrator?
    permitted_attributes
  end

  private

  def encyclopaedia_entry_attributes
    related_id_attributes + [
      :category_id,
      :name,
      :encyclopaedia_entry_picture,
      :information,
      :content,
      contributor_profile_ids: [],
      illustrations_attributes: [:id, :illustration, :_destroy]
    ]
  end

  def related_id_attributes
    [
      article_ids: [],
      download_ids: [],
      link_ids: [],
      music_track_ids: [],
      picture_ids: [],
      poem_ids: [],
      quiz_ids: [],
      resource_ids: [],
      story_ids: [],
      video_ids: []
    ]
  end
end
