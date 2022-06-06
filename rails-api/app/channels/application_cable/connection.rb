module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      ws_token = request.original_fullpath.sub("/cable?ws_token=", "")
      user_params = crypt.decrypt_and_verify(ws_token)
      uid           = user_params[:uid]
      client        = user_params[:client]
      access_token  = user_params[:access_token]
      self.current_user = find_verified_user access_token, uid, client
    rescue ActiveSupport::MessageEncryptor::InvalidMessage => e
      Rails.logger.error e.message
      reject_unauthorized_connection
    rescue => e
      Rails.logger.info e.message
      reject_unauthorized_connection
    end


    protected
    
    def find_verified_user token, uid, client_id # this checks whether a user is authenticated with devise
        user = User.find_by email: uid
        if user && user.valid_token?(token, client_id)
            user
        else
            reject_unauthorized_connection
        end
    end

    def crypt
      @crypt ||= ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base[0..31])
    end
  end
end