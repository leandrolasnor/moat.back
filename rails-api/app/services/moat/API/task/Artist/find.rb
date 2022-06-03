class Moat::API::Task::Artist::Find < ApplicationService
  def headers
    {"Basic"  => Rails.application.credentials.moat[:token]}
  end

  def url
    "#{ENV['MOAT_URI']}/?artist_id=#{@params}"
  end

  def call
    response = HTTParty.get(url, headers: headers)
    return JSON.parse(response.body, symbolize_names: true).first if response.code == 200
    Rails.logger.info response.inspect
    return nil
  end
end