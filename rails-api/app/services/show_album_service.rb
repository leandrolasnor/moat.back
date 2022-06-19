class ShowAlbumService < ApplicationService
  def call
    HandleShowAlbumWorker.perform_async(params)
    handle_response
  rescue => e
    error_response e
  end
end