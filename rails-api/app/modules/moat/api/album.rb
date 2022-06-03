module 1  ::Album

  def self.prepended(mod)
    raise NameError.new("Only model #{Album.name} can prepend this #{self}") if mod.to_s != Album.name
  end

  def artist
    @artist ||= get_artist if self.artist_id.present?
  end

  def get_artist
    response = HTTParty.get("#{uri}?artist_id=#{self.artist_id}", headers: headers)
    return JSON.parse(response.body, symbolize_names: true).first if response.code == 200
    Rails.logger.info response.inspect
    nil
  rescue => e
    Rails.logger.info e.inspect
    nil
  end

  def headers
    {"Basic"  => Rails.application.credentials.moat[:token]}
  end

  def uri
    ENV['MOAT_URI']
  end
end