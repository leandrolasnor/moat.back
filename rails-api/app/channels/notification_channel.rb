class NotificationChannel < ApplicationCable::Channel
	def subscribed
		reject if current_user.nil?
		stream_from current_user.to_gid_param unless current_user.nil?
	end
end