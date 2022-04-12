module Shared::AlbumsHelper
  def previous_albumable(albumable)
    albumables = ordered_albumables(albumable.album)
    previous_index = albumables.index(albumable) - 1
    albumables[previous_index] if previous_index >= 0
  end

  def next_albumable(albumable)
    albumables = ordered_albumables(albumable.album)
    next_index = albumables.index(albumable) + 1
    albumables[next_index] if next_index < albumables.length
  end

  def ordered_albumables(album)
    album.ordered_pictures + album.ordered_videos
  end

  def album_has_at_least_one_albumable(album)
    (album.pictures && album.pictures.count > 0) ||
      (album.videos && album.videos.count > 0)
  end

  def albumable_path(albumable)
    return redesign_picture_path(albumable) if albumable.class == Picture
    return redesign_video_path(albumable) if albumable.class == Video
  end
end
