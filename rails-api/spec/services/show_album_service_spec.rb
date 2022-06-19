require 'rails_helper'

RSpec.describe ShowAlbumService, type: :service do
  
  context "calling service" do
    let(:params) {{id: 1}}
    let(:service) { described_class.call(params) }
    
    before do
      allow(HandleShowAlbumWorker).to receive(:perform_async).with(params)
    end

    it 'must to return successful body content' do
      expect(service).to eq successful_response
      expect(HandleShowAlbumWorker).to have_received(:perform_async).with(params).once
    end
  end
end