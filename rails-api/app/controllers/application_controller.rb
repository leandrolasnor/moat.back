class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def not_found
    render body: nil, :status => 404
  end

  protected

    def configure_permitted_parameters
        added_attrs = [:email, :last_name, :name, :role, :password, :password_confirmation, :remember_me]
        devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
        devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    end
end
