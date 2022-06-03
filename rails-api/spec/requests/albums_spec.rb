require 'rails_helper'

RSpec.describe "/albums", type: :request do

  let(:valid_attributes) {{name: Faker::Quotes::Chiquito.expression, year: rand(1948..Time.now.year).to_i, artist_id: [1,2,3,4,5].sample}}

  let(:valid_headers) { get_headers }

  let(:valid_headers_admin) { get_headers(admin:1) }

  describe "GET /show" do
    it "renders a successful response" do
      album = Album.create! valid_attributes
      get album_path(album.id), headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /search" do
    it "renders a successful response" do
      get albums_search_path, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "PUT /update" do
    it "renders a successful response" do
      album = Album.create! valid_attributes
      put album_path(album.id), params: {album: {name: Faker::Quotes::Chiquito.expression}}, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "PATCH /update" do
    it "renders a successful response" do
      album = Album.create! valid_attributes
      patch album_path(album.id), params: {album: {name: Faker::Quotes::Chiquito.expression}}, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    it "renders a successful response" do
      post albums_path, params: {album: valid_attributes}, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "DELETE /destroy" do
    context "renders a unauthorized response" do
      it "when user is not admin" do
        album = Album.create! valid_attributes
        delete album_path(album.id), headers: valid_headers, as: :json
        expect(response).to be_unauthorized
      end
    end

    context "renders a successful response" do
      it "when user is admin" do
        album = Album.create! valid_attributes
        delete album_path(album.id), headers: valid_headers_admin, as: :json
        expect(response).to be_successful
      end
    end
  end
end
