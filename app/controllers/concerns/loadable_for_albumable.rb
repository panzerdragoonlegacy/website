module LoadableForAlbumable
  extend ActiveSupport::Concern

  def load_albums
    @albums = AlbumPolicy::Scope.new(current_user, Album.order(:name)).resolve
  end
end
