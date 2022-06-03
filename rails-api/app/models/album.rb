class Album < ApplicationRecord
  validates :artist_id, :name, presence: true
  validates :year, numericality: { only_integer: true, greater_than_or_equal_to: 1948 }, presence: true

  def artist
    @artist ||= Moat::API::Task::Artist::Find.call(self.artist_id)
  end
end
