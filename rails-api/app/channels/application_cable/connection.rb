module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :client

    def connect
      ws_token = request.original_fullpath.sub("/cable?ws_token=", "")
      user_params = crypt.decrypt_and_verify(ws_token)
      uid           = user_params[:uid]
      client        = user_params[:client]
      access_token  = user_params[:access_token]
      self.client = client if authentic(access_token, uid, client)
    rescue => e
      Rails.logger.error e.message
      reject_unauthorized_connection
    end


    protected
    
    def authentic(token, uid, client_id) # this checks whether a user is authenticated with devise
        user = User.find_by email: uid
        return (user && user.valid_token?(token, client_id))
    end

    def crypt
      @crypt ||= ActiveSupport::MessageEncryptor.new(Rails.application.credentials.dig(:secret_key_base)[0..31])
    end
  end
end