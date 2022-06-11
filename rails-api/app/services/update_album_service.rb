class UpdateAlbumService < ApplicationService
  def call
    HandleUpdateAlbumWorker.perform_async(params)
    handle_response
  rescue => e
    error_response e
  end
end