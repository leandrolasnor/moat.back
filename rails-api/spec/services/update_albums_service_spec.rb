require 'rails_helper'

RSpec.describe UpdateAlbumService, type: :service do
  
  context "calling service" do
    let(:params) {{id: 1}}
    let(:service) { described_class.call(params) }
    
    before do
      allow(HandleUpdateAlbumWorker).to receive(:perform_async).with(params)
    end

    it 'must to return successful body content' do
      expect(service).to eq successful_response
      expect(HandleUpdateAlbumWorker).to have_received(:perform_async).with(params).once
    end
  end
end