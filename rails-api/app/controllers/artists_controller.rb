class ArtistsController < ApiController
  def list
    authorize! :create, Album
    deliver GetArtistsMoatApiService.call moat_api_param
  end

  private 

  def artist_params
    params.fetch(:artist, {}).merge(headers_params)
  end

  def moat_api_param
    artist_params.permit(:uid)
  end
end
