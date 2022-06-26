class SearchAlbumsService < ApplicationService
  def call
    params[:query] = sanitize do
      ['LOWER(name) like ?', "%#{params.dig(:query)}%"]
    end
    HandleSearchAlbumsWorker.perform_async(params)
    handle_response
  rescue => e
    error_response e
  end
end