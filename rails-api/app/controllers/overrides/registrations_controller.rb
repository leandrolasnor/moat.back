module Overrides
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
  
    protected
  
    def render_create_success
      
      render json: @resource, serializer: UserLoginSerializer, ws_token: ws_token, status: :ok
    end

    def ws_token 
      @ws_token ||= ActiveSupport::MessageEncryptor.new(Rails.application.credentials.dig(:secret_key_base)[0..31]).encrypt_and_sign(
        {
          uid:          @resource[:uid],
          access_token: @token.token,
          client:       @token.client
        }
      )
    end
  end
end