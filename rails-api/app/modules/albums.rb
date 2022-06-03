module Albums
  class << self
    def create(params)
      album = Factory.make params
      yield album, nil
    rescue ActiveRecord::RecordInvalid => e
      yield nil, e.record.errors.full_messages
    rescue => e
      raise e
    end

    def update(params)
      album = Album.find(params['id']) # ActiveRecord::RecordNotFound
      album.update!(params.slice('name','year','artist_id'))
      yield album, nil
    rescue ActiveRecord::RecordInvalid => e
      yield nil, e.record.errors.full_messages
    rescue ActiveRecord::RecordNotFound => e
      yield nil, e.message
    rescue => e
      raise e
    end

    def search(params)
      @params = params
      pagination = paginate(Album.where(params['query']))
      albums = pagination.to_json
      raise(ActiveRecord::RecordNotFound.new('Record not found', Album)) if albums.blank?
      yield albums, pagination.header_params, nil
    rescue => e
      yield nil, nil, e.message
    end

    def delete(params)
      deleted = Sweeper.make(params)
      yield deleted, nil
    rescue ActiveRecord::RecordNotDestroyed => e
      yield nil, e.record.errors.full_messages
    rescue ActiveRecord::RecordNotFound => e
      yield nil, e.message
    rescue => e
      raise e
    end

    private

    def paginate(items)
      Pagination.new(items, @params['pagination']['current_page'] || 1, @params['pagination']['per_page'] || 10, ManyAlbumsSerializer)
    end
  end

  module Sweeper
    class << self
      def make(params)
        album = Album.find(params['id']) # ActiveRecord::RecordNotFound
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
          s.name    = params['name']
          s.year = params['year']
          s.artist_id = params['artist_id']
        end
        album.save!
        return album
      rescue => e
        raise e
      end
    end
  end
end