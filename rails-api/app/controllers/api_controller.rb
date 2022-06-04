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

  def headers_params
    {
      uid: request.headers[:uid],
      pagination:{
        current_page: request.headers[:current_page] || 1,
        per_page: request.headers[:per_page] || 10
      }
    }
  end

  def deliver(content:, status:)
    render json: content, status: status
  end
end