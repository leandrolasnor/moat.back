class HandleSearchAlbumsWorker
  include Sidekiq::Worker
	sidekiq_options retry: false

  def perform(params)
		params = params.deep_symbolize_keys!
		Albums::search(params) do |data, errors|
			ActionCable.server.broadcast params[:channel],{type: 'ALBUMS_FETCHED', payload:data} if data.present?
			ActionCable.server.broadcast params[:channel],{type: 'ERRORS_FROM_SEARCH_ALBUMS', payload:{errors: errors}} if errors.present?
		end
	rescue => e
		Rails.logger.error e.inspect
		ActionCable.server.broadcast params[:channel],{type: 'INTERNAL_SERVER_ERROR', payload:{message: 'HTTP 500 Internal Server Error'}}
	end
end