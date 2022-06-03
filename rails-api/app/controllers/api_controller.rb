class ApiController < ApplicationController
  before_action :authenticate_user!

  rescue_from StandardError, with: :error
  rescue_from CanCan::AccessDenied, with: :deny_access
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  def deny_access
    render body: nil, :status => :unauthorized
  end

  def not_found
    render body: nil, :status => :not_found
  end

  def error(e)
    Rails.logger.error e.inspect
    render body: nil, :status => :internal_server_error
  end
end