class AlbumsController < ApiController
  before_action :set_album, only: [:show]

  def search
    authorize! :read, Album
    deliver SearchAlbumsService.call album_search_params
  end

  def show
    authorize! :read, Album
    render json: @album, serializer: ShowAlbumSerializer
  end

  def create
    authorize! :create, Album
    deliver CreateAlbumService.call album_create_params
  end

  def update
    authorize! :update, Album
    deliver UpdateAlbumService.call album_update_params
  end

  def destroy
    authorize! :destroy, Album
    deliver RemoveAlbumService.call album_destroy_params
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
      album_params.merge(
        {
          id: params[:id], 
          channel:current_user.to_gid_param
        }
      ).permit(:id, :uid, :channel)
    end

    def album_update_params
      album_params.merge({id: params[:id]}).permit(:id, :name,:year,:artist_id, :uid)
    end

    def album_search_params
      album_params.merge(query: params.dig(:query)).permit(:query, :uid, {pagination: [:current_page, :per_page]})
    end
end
