module Moat::Api
  class << self
    def artists
      response = HTTParty.get(url, headers: headers)
      if response.code == 200
        yield JSON.parse(response.body, symbolize_names: true).flatten, nil
      else
        Rails.logger.info response.inspect
        yield [], response.code
      end
    rescue => e
      Rails.logger.info e.inspect
      yield [], e.message
    end

    def headers
      {"Basic"  => Rails.application.credentials.moat[:token]}
    end
  
    def url
      ENV['MOAT_URI']
    end
  end
end