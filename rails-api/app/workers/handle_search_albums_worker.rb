class HandleSearchAlbumsWorker
  include Sidekiq::Worker
	sidekiq_options retry: false

  def perform(params)
		@params = JSON.parse(params)
		Albums::search(@params) do |albums, pagination, errors|
			ActionCable.server.broadcast user.to_gid_param, {
				type: "ALBUMS_FETCHED", payload:{
					albums: albums}}.to_json if albums.present?
			ActionCable.server.broadcast user.to_gid_param, {
				type: "PAGINATION_ALBUMS", payload:{
					pagination: pagination}}.to_json if pagination.present?
			ActionCable.server.broadcast user.to_gid_param, {
				type: "ERRORS_FROM_SEARCH_ALBUMS", payload:{
					errors: errors}}.to_json if errors.present?
		end
	rescue => e
		Rails.logger.error e.inspect
		ActionCable.server.broadcast user.to_gid_param,{
			type: "INTERNAL_SERVER_ERROR", payload:{
				message: "HTTP 500 Internal Server Error"
			}
		}
	end

	private

	def user
		@user ||= User.find(@params["uid"])
	end
end