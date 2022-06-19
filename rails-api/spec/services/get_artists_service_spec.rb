require 'rails_helper'

RSpec.describe GetArtistsService, type: :service do
  
  context "calling service" do
    let(:service) { described_class.call }
    
    before do
      allow(HandleGetArtistsWorker).to receive(:perform_async)
    end

    it 'must to return successful body content' do
      expect(service).to eq successful_response
      expect(HandleGetArtistsWorker).to have_received(:perform_async).once
    end
  end
end