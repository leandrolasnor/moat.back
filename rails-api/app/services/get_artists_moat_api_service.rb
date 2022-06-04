class GetArtistsMoatApiService < ApplicationService
  def call
    HandleGetArtistsMoatApiWorker.perform_async(@params.to_json)
    handle_response
  rescue => e
    error_response e
  end
end