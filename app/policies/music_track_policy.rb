class MusicTrackPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user
        return scope if user.administrator?
        return scope_user_contributes_to if user.contributor_profile
      end
      scope.where publish: true
    end

    private

    def scope_user_contributes_to
      scope
        .joins(:category, :contributions)
        .where(
          'music_tracks.publish = true OR ' \
            'contributions.contributor_profile_id = ?',
          user.contributor_profile_id
        )
    end
  end

  def show?
    if user
      return true if user.administrator?
      return true if user_contributes_to_record?
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
    permitted_attributes = attributes_except_publish
    permitted_attributes << :publish if user && user.administrator?
    permitted_attributes
  end

  private

  def attributes_except_publish
    file_attributes + [
      :category_id,
      :track_number,
      :name,
      :description,
      :information,
      contributor_profile_ids: [],
      tag_ids: []
    ]
  end

  def file_attributes
    %i[mp3_music_track flac_music_track music_track_picture]
  end
end
