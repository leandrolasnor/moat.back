class Moat::API::Task::Artist::All < ApplicationService
  def headers
    {"Basic"  => Rails.application.credentials.moat[:token]}
  end

  def url
    "#{ENV['MOAT_URI']}"
  end

  def call
    response = HTTParty.get(url, headers: headers)
    return JSON.parse(response.body, symbolize_names: true).flatten if response.code == 200
    Rails.logger.info response.inspect
    return []
  end
end