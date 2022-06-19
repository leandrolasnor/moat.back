module Moat::Api::Artist
  class << self
    def all
      uri = ENV['MOAT_URI']
      headers = {"Basic"  => Rails.application.credentials.dig(:moat, :token)}
      response = HTTParty.get(uri, headers: headers)
      return JSON.parse(response.body, symbolize_names: true).flatten if response.code == 200
      Rails.logger.error({ from: "Moat::Artist.all", code: response.code, body: response.body })
      []
    end
  end
end