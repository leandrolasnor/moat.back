class GetArtistsService < ApplicationService
  def call
    HandleGetArtistsWorker.perform_async(params)
    handle_response
  rescue => e
    error_response e
  end
end