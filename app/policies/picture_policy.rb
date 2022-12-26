class PicturePolicy < ApplicationPolicy
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
      scope.where(publish: true)
    end

    private

    def scope_user_contributes_to
      scope
        .joins(:contributions)
        .where(
          'pictures.publish = true OR contributions.contributor_profile_id = ?',
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
    return unless user
    return true if user.administrator?
    return true if user_contributes_to_record? && !record.publish
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def permitted_attributes
    permitted_attributes = attributes_except_publish
    permitted_attributes << :publish if user&.administrator?
    permitted_attributes
  end

  private

  def attributes_except_publish
    file_attributes + [
      :category_id,
      :album_id,
      :sequence_number,
      :name,
      :description,
      :information,
      :source_url,
      :instagram_post_id,
      :full_size_link,
      :controversial_content,
      contributor_profile_ids: [],
      tag_ids: []
    ]
  end

  def file_attributes
    %i[id_of_picture_to_replace picture]
  end
end
