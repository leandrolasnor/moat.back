class Album < ApplicationRecord
  validates :artist_id, :name, presence: true
  validates :year, numericality: { only_integer: true, greater_than: 1947 }, presence: true
end
