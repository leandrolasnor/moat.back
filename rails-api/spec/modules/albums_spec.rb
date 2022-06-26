require 'rails_helper'

RSpec.describe Albums, type: :module do

  context "#show" do
    let(:album) {AlbumSerializer.new(create(:album)).serializable_hash}
    let(:params){{id: album[:id]}}
    let(:params_invalid){{id: 999}}

    before do
      allow_any_instance_of(Album).to receive(:artist).and_return({})
    end

    it "fetches a album" do
      described_class::show(params) do |instance, error|
        expect(instance).to eq(album)
        expect(error).to eq(nil)
      end
    end

    it "album not found" do
      described_class::show(params_invalid) do |instance, error|
        expect(instance).to eq(nil)
        expect(error).to be_an_instance_of(Array)
      end
    end
  end

  context "#create" do
    let(:params){{name: 'Teste', year: 2022, artist_id:1}}
    let(:params_invalid){{name: '', year: 0, artist_id:0}}

    it "new album" do
      described_class::create(params) do |album, error|
        expect(album).to be_an_instance_of(Album)
        expect(error).to eq(nil)
      end
    end

    it "params invalids" do
      described_class::create(params_invalid) do |instance, error|
        expect(instance).to eq(nil)
        expect(error).to be_an_instance_of(Array)
      end
    end
  end

  context "#update" do
    let(:album){create(:album)}
    let(:params) {AlbumSerializer.new(album).serializable_hash.merge!(name: 'Teste', artist_id: 1)}
    let(:params_invalid){params.merge!(year: 1500)}
    let(:params_invalid_id){params.merge!(id: 999)}

    before do
      allow_any_instance_of(Album).to receive(:artist).and_return({})
    end

    it "album updated" do
      described_class::update(params) do |album, error|
        expect(album).to be_an_instance_of(Album)
        expect(album[:name]).to eq('Teste')
        expect(error).to eq(nil)
      end
    end

    it "fields invalids" do
      described_class::update(params_invalid) do |album, error|
        expect(album).to eq(nil)
        expect(error).to be_an_instance_of(Array)
      end
    end

    it "album not found" do
      described_class::update(params_invalid_id) do |instance, error|
        expect(instance).to eq(nil)
        expect(error).to be_an_instance_of(Array)
        expect(error.first).to eq("Couldn't find Album with 'id'=999")
      end
    end
  end

  context "#search" do
    let(:album) { create(:album) }
    let(:params){ {query: "LOWER(name) like '%#{album[:name].downcase!.first}%'"} }
    let(:params_invalid){ {query: "LOWER(name) like '%XXX%'"} }

    it "fetches albums" do
      described_class::search(params) do |payload, error|
        p payload[:albums].class
        expect(payload[:albums]).to be_an_instance_of(Album::ActiveRecord_Relation)
        expect(payload[:albums].first).to eq(album)
        expect(payload[:albums].count).to eq(1)
        expect(error).to eq(nil)
      end
    end

    it "albums is a empty array" do
      described_class::search(params_invalid) do |payload, error|
        expect(payload[:albums]).to be_an_instance_of(Album::ActiveRecord_Relation)
        expect(payload[:albums]).to eq([])
        expect(error).to be_an_instance_of(Array)
      end
    end
  end
end