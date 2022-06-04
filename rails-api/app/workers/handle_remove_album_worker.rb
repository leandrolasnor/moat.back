class HandleRemoveAlbumWorker
  include Sidekiq::Worker
	sidekiq_options retry: false

  def perform(params)
    @params = JSON.parse(params)
		Albums::delete(@params) do |album, errors|
			ActionCable.server.broadcast @params['channel'], {
				type: 'ALBUM_REMOVED', payload:{ 
					album: album}} if album.present?
			ActionCable.server.broadcast @params['channel'], {
				type: 'ERRORS_FROM_ALBUM_REMOVED', payload:{
					errors: errors}} if errors.present?
		end
	rescue => e
		Rails.logger.error e.inspect
		ActionCable.server.broadcast @params['channel'],{
			type: "500", payload:{
				message: "HTTP 500 Internal Server Error"}}.to_json
	end
end