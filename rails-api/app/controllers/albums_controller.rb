class AlbumsController < ApiController
  before_action :set_album, only: [:show]

  def index
    SearchAlbumsService.call album_search_params
  end

  def show
    render json: @album, serializer: AlbumSerializer
  end

  def create
    CreateAlbumsService.call album_create_params
  end

  def update
    UpdateAlbumService.call album_update_params
  end

  def destroy
    RemoveAlbumService.call album_destroy_params
  end

  private

    def set_album
      @album = Album.find(params[:id])
    end

    def album_params
      params.fetch(:album, {}).merge(headers_params)
    end

    def album_create_params
      album_params.permit(:name,:year,:artist_id, :uid)
    end

    def album_destroy_params
      album_params.permit(:id, :uid)
    end

    def album_update_params
      album_params.permit(:id, :name,:year,:artist_id, :uid)
    end

    def album_search_params
      album_params.permit(:query, :uid, {pagination: [:current_page, :per_page]})
    end

    def headers_params
      {
        uid: request.headers[:uid],
        pagination:{
          current_page: request.headers[:current_page] || 1,
          per_page: request.headers[:per_page] || 10
        }
      }
    end
end
