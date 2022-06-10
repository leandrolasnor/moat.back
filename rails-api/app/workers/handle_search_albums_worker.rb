class HandleSearchAlbumsWorker
  include Sidekiq::Worker
	sidekiq_options retry: false

  def perform(params)
		handle params
		Albums::search(@params) do |data, errors|
			ActionCable.server.broadcast user.to_gid_param, {
				type: 'ALBUMS_FETCHED', payload:data} if data.present?
			ActionCable.server.broadcast user.to_gid_param, {
				type: 'ERRORS_FROM_SEARCH_ALBUMS', payload:{
					errors: errors}} if errors.present?
		end
	rescue => e
		Rails.logger.error e.inspect
		ActionCable.server.broadcast user.to_gid_param,{
			type: 'INTERNAL_SERVER_ERROR', payload:{
				message: 'HTTP 500 Internal Server Error'
			}
		}
	end

	private

	def user
		@user ||= User.find(@params[:uid])
	end

	def handle(params)
		@params = JSON.parse(params).deep_symbolize_keys!
	end
end