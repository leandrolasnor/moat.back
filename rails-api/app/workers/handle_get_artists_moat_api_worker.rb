class HandleGetArtistsMoatApiWorker
  include Sidekiq::Worker
	sidekiq_options retry: false

  def perform(params)
    @params = JSON.parse(params)
    Moat::Api.artists do |list, errors|
      ActionCable.server.broadcast user.to_gid_param, {
        type: 'ARTISTS_FETCHED', payload:{
          artists: list}} if list.present?
      ActionCable.server.broadcast user.to_gid_param, {
        type: 'ERRORS_FROM_ARTISTS_FETCHED', payload:{
          errors: errors}} if errors.present?
    end
	rescue => e
		Rails.logger.error e.inspect
		ActionCable.server.broadcast user.to_gid_param,{
			type: '500', payload:{
				message: 'HTTP 500 Internal Server Error'}}
	end

  private

	def user
		@user ||= User.find(@params['uid'])
	end
end