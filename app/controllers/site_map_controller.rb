class SiteMapController < ApplicationController
  after_action :verify_authorized, except: [:show]

  def show
    @article_categories = policy_scope(Category.where(
      category_type: :article).order(:name))
    @download_categories = policy_scope(Category.where(
      category_type: :download).order(:name))
    @encyclopaedia_entry_category_groups = policy_scope(CategoryGroup.where(
      category_group_type: :encyclopaedia_entry).order(:name))
    @link_categories = policy_scope(Category.where(
      category_type: :link).order(:name))
    @music_track_category_groups = policy_scope(CategoryGroup.where(
      category_group_type: :music_track).order(:name))
    @picture_category_groups = policy_scope(CategoryGroup.where(
      category_group_type: :picture).order(:name))
    @resource_category_groups = policy_scope(CategoryGroup.where(
      category_group_type: :resource).order(:name))
    @story_categories = policy_scope(Category.where(
      category_type: :story).order(:name))
    @video_category_groups = policy_scope(CategoryGroup.where(
      category_group_type: :video).order(:name))
  end
end
