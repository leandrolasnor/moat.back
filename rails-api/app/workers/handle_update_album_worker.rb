class HandleUpdateAlbumWorker
  include Sidekiq::Worker
	sidekiq_options retry: false

  def perform(params)
    @params = JSON.parse(params)
		Albums::update(@params) do |album, errors|
			ActionCable.server.broadcast user.to_gid_param, {
				type: 'ALBUM_UPDATED', payload:{
					album: album}} if album.present?
			ActionCable.server.broadcast user.to_gid_param, {
				type: 'ERRORS_FROM_ALBUM_UPDATED', payload:{
					errors: errors}} if errors.present?
		end
	rescue => e
		Rails.logger.error e.inspect
		ActionCable.server.broadcast user.to_gid_param, {
			type: '500', payload:{
				message: 'HTTP 500 Internal Server Error'}}
	end

  private

	def user
		@user ||= User.find(@params['uid'])
	end
end