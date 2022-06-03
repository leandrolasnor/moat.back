class RemoveAlbumService < ApplicationService
  def call
    HandleRemoveAlbumWorker.perform_async(params)
    handle_response
  rescue => e
    error_response e
  end
end