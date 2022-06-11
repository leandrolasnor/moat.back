class CreateAlbumService < ApplicationService
  def call
    HandleCreateAlbumWorker.perform_async(params)
    handle_response
  rescue => e
    error_response e
  end
end