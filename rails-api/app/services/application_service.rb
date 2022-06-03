class ApplicationService
  private_class_method :new

  def self.call(params = nil)
    new(params).call
  end

  def initialize(params = nil)
    @params ||= params
  end

  def call; end

  private

  attr_reader :params

  def handle_response
    { content: { code: 0, message: 'ok' }, status: :ok }
  end

  def error_response(e)
    Rails.logger.error e.inspect
    { content: { code: -1, message: 'failure' }, status: 	:internal_server_error }
  end

  def sanitize
    ApplicationRecord.sanitize_sql_for_conditions yield
  end
end