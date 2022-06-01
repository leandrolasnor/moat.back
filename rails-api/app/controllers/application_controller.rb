class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  
  before_action :authenticate_user!

  def not_found
    render body: nil, :status => 404
  end
end
