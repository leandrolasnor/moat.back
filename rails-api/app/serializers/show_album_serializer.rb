class ShowAlbumSerializer < ActiveModel::Serializer
  attributes :id, :name, :year, :artist

  def artist
    object.artist
  end
end
