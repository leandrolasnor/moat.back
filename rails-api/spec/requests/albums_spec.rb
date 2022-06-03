require 'rails_helper'

RSpec.describe "/albums", type: :request do

  let(:valid_attributes) {{name: Faker::Quotes::Chiquito.expression, year: rand(1948..Time.now.year).to_i, artist_id: [1,2,3,4,5].sample}}

  let(:valid_headers) { get_headers }

  describe "GET /show" do
    it "renders a successful response" do
      album = Album.create! valid_attributes
      get album_path(album.id), headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end
end
