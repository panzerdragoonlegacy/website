class VideoPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user
        return scope if user.administrator?
        if user.contributor_profile.present?
          return scope.joins(:contributions).where(
            "videos.publish = 't'" +
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
      if user.contributor_profile.present?
        if record.contributions.where(
          contributor_profile_id: user.contributor_profile_id
        ).count > 0
          return true
        end
      end
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
      if user.contributor_profile.present?
        if !record.publish && record.contributions.where(
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
    edit?
  end

  def permitted_attributes
    permitted_attributes = [
      :category_id,
      :name,
      :description,
      :information,
      :mp4_video,
      :youtube_video_id,
      contributor_profile_ids: [],
      encyclopaedia_entry_ids: []
    ]
    if user
      permitted_attributes << :publish if user.administrator?
    end
    permitted_attributes
  end
end
