class SiteMapController < ApplicationController
  after_action :verify_authorized, except: [:show]

  def show
    load_article_categories
    load_download_categories
    load_encyclopaedia_entry_category_groups
    load_link_categories
    load_music_track_category_groups
    load_picture_category_groups
    load_resource_category_groups
    load_story_categories
    load_video_category_groups
  end

  private

  def load_article_categories
    @article_categories = policy_scope(
      Category.where(category_type: :article).order(:name)
    )
  end

  def load_download_categories
    @download_categories = policy_scope(
      Category.where(category_type: :download).order(:name)
    )
  end

  def load_encyclopaedia_entry_category_groups
    @encyclopaedia_entry_category_groups = policy_scope(
      CategoryGroup.where(
        category_group_type: :encyclopaedia_entry
      ).order(:name)
    )
  end

  def load_music_track_category_groups
    @music_track_category_groups = policy_scope(
      CategoryGroup.where(category_group_type: :music_track).order(:name)
    )
  end

  def load_link_categories
    @link_categories = policy_scope(
      Category.where(category_type: :link).order(:name)
    )
  end

  def load_picture_category_groups
    @picture_category_groups = policy_scope(
      CategoryGroup.where(category_group_type: :picture).order(:name)
    )
  end

  def load_resource_category_groups
    @resource_category_groups = policy_scope(
      CategoryGroup.where(category_group_type: :resource).order(:name)
    )
  end

  def load_story_categories
    @story_categories = policy_scope(
      Category.where(category_type: :story).order(:name)
    )
  end

  def load_video_category_groups
    @video_category_groups = policy_scope(
      CategoryGroup.where(category_group_type: :video).order(:name)
    )
  end
end
