class HandleGetArtistsWorker
  include Sidekiq::Worker
	sidekiq_options retry: false

  def perform(params)
    @params = JSON.parse(params)
    artists = Moat::Artist.all
    ActionCable.server.broadcast(
      user.to_gid_param, 
      { type: 'ARTISTS_FETCHED', payload:{artists: artists} }
    )
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