class ApplicationController < ActionController::API
        include DeviseTokenAuth::Concerns::SetUserByToken
  def not_found
    render body: nil, :status => 404
  end
end
