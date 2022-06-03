class Album < ApplicationRecord
  prepend Moat::Api::Album

  validates :artist_id, :name, presence: true
  validates :year, numericality: { only_integer: true, greater_than_or_equal_to: 1948 }, presence: true
end
