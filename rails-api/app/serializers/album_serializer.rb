class AlbumSerializer < ActiveModel::Serializer
  attributes :id, :name, :year, :artist
end
