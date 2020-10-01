class SiteMapController < ApplicationController
  after_action :verify_authorized, except: [:show]

  def show
    if params[:browse_by] == 'media_type'
      load_literature_category_groups
      load_download_category_groups
      load_encyclopaedia_category_groups
      load_music_track_category_groups
      load_picture_category_groups
      load_video_category_groups
      load_share_category_groups
    elsif params[:browse_by] == 'tag'
      load_tags
    else
      load_categories_grouped_by_saga
    end
  end

  private

  def load_categories_grouped_by_saga
    @all_sagas = {}
    Saga.order(:sequence_number).each do |saga|
      media_types = {}
      MediaType::all.each do |key, value|
        media_types[value] = policy_scope(
          saga.categories.where(category_type: key.to_s).order(:name)
        )
      end
      @all_sagas[saga] = media_types
    end
  end

  def load_literature_category_groups
    @literature_category_groups = policy_scope(
      CategoryGroup.where(category_group_type: :literature).order(:name)
    )
  end

  def load_download_category_groups
    @download_category_groups = policy_scope(
      CategoryGroup.where(category_group_type: :download).order(:name)
    )
  end

  def load_encyclopaedia_category_groups
    @encyclopaedia_category_groups = policy_scope(
      CategoryGroup.where(category_group_type: :encyclopaedia).order(:name)
    )
  end

  def load_music_track_category_groups
    @music_track_category_groups = policy_scope(
      CategoryGroup.where(category_group_type: :music_track).order(:name)
    )
  end

  def load_picture_category_groups
    @picture_category_groups = policy_scope(
      CategoryGroup.where(category_group_type: :picture).order(:name)
    )
  end

  def load_video_category_groups
    @video_category_groups = policy_scope(
      CategoryGroup.where(category_group_type: :video).order(:name)
    )
  end

  def load_share_category_groups
    @share_category_groups = policy_scope(
      CategoryGroup.where(category_group_type: :share).order(:name)
    )
  end

  def load_tags
    @tags = policy_scope(Tag.order(:name).page(params[:page]))
  end
end
