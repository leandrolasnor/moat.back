class Album < ApplicationRecord
  validates :artist_id, :name, presence: true
  validates :year, numericality: { only_integer: true, greater_than_or_equal_to: 1948 }, presence: true
  default_scope { order(created_at: :desc) }

  def artist
    @artist ||= Moat::Artist.find(self.artist_id)
  end
end
