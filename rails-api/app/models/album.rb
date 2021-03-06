class Album < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :artist_id
  validates :year, numericality: { only_integer: true, greater_than_or_equal_to: 1948 }, presence: true
  default_scope { order(created_at: :desc) }

  def artist
    @artist ||= moat.artist
  end

  private
  def moat
    @moat ||= Moat::Api::Album.new(self)
  end
end
