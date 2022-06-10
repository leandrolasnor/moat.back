class Moat::Artist
  private_class_method :new

  def initialize
    @uri = ENV['MOAT_URI']
    @headers = {"Basic"  => Rails.application.credentials.dig(:moat, :token)}
  end

  def self.find(id)
    new.find(id)
  end

  def self.all
    new.all
  end

  def find(id)
    response = HTTParty.get("#{@uri}?artist_id=#{id}", headers: @headers)
    return JSON.parse(response.body, symbolize_names: true).first if response.code == 200
    raise ActiveRecord::RecordNotFound
  end

  def all
    response = HTTParty.get(@uri, headers: @headers)
    return JSON.parse(response.body, symbolize_names: true).flatten if response.code == 200
    Rails.logger.info response.inspect
    []
  end
end