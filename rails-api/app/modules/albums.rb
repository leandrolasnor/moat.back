module Albums
  class << self
    include Pagination
    attr_reader :params

    def show(params)
      album = AlbumSerializer.new(Album.find(params[:id])).serializable_hash # ActiveRecord::RecordNotFound
      yield album, nil
    rescue ActiveRecord::RecordNotFound => e
      yield nil, [e.message]
    rescue => e
      raise e
    end

    def create(params)
      album = Factory.make params
      yield album, nil
    rescue ActiveRecord::RecordInvalid => e
      yield nil, e.record.errors.full_messages
    rescue => e
      raise e
    end

    def update(params)
      album = Album.find(params[:id]) # ActiveRecord::RecordNotFound
      album.update!(params.slice(:name,:year,:artist_id))
      yield album, nil
    rescue ActiveRecord::RecordInvalid => e
      yield nil, e.record.errors.full_messages
    rescue ActiveRecord::RecordNotFound => e
      yield nil, [e.message]
    rescue => e
      raise e
    end

    def search(params)
      @params = params
      albums = Album.where(params[:query]).then(&paginate)
      yield({ albums: albums, pagination: pagination }, nil)
    rescue StandardError, ActiveRecord::RecordNotFound => e
      yield nil, [e.message]
    end

    def delete(params)
      deleted = Sweeper.make(params)
      yield deleted, nil
    rescue ActiveRecord::RecordNotDestroyed => e
      yield nil, e.record.errors.full_messages
    rescue ActiveRecord::RecordNotFound => e
      yield nil, [e.message]
    rescue => e
      raise e
    end
  end

  module Sweeper
    class << self
      def make(params)
        album = Album.find(params[:id]) # ActiveRecord::RecordNotFound
        album.destroy! # ActiveRecord::RecordNotDestroyed
      rescue => e
        raise e
      end
    end
  end

  module Factory
    class << self
      def make(params)
        album = Album.new do |s|
          s.name      = params[:name]
          s.year      = params[:year]
          s.artist_id = params[:artist_id]
        end
        album.save!
        return album
      rescue => e
        raise e
      end
    end
  end
end