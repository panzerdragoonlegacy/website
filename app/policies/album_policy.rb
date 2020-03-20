class AlbumPolicy < ApplicationPolicy
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
      scope.joins(:category).where(publish: true, categories: { publish: true })
    end

    private

    def scope_user_contributes_to
      scope.joins(:category, :contributions).where(
        '(albums.publish = true AND categories.publish = true) OR ' \
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
    record.publish? && record.category.publish?
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
    edit? if record.pictures.blank?
  end

  def permitted_attributes
    permitted_attributes = attributes_except_publish
    permitted_attributes << :publish if user && user.administrator?
    permitted_attributes
  end

  private

  def attributes_except_publish
    shared_attributes + [
      :category_id,
      :instagram_post_id,
      contributor_profile_ids: [],
      tag_ids: [],
      pictures_attributes: pictures_attributes,
      videos_attributes: videos_attributes
    ]
  end

  def pictures_attributes
    shared_attributes + [
      :id,
      :category_id,
      :instagram_post_id,
      :picture,
      :_destroy,
      contributor_profile_ids: [],
      tag_ids: []
    ]
  end

  def videos_attributes
    shared_attributes + [
      :id,
      :category_id,
      :video_picture,
      :mp4_video,
      :_destroy,
      contributor_profile_ids: [],
      tag_ids: []
    ]
  end

  def shared_attributes
    [
      :sequence_number,
      :source_url,
      :name,
      :description,
      :information
    ]
  end
end
