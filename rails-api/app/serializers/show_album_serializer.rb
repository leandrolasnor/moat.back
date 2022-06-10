class ShowAlbumSerializer < ActiveModel::Serializer
  attributes :id, :name, :year, :artist
end
