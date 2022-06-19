require 'rails_helper'

RSpec.describe SearchAlbumsService, type: :service do
  
  context "calling service" do
    context "with query param" do
      let(:params) {{query: 'some albums name'}}
      let(:service) { described_class.call(params) }
      
      before do
        allow(HandleSearchAlbumsWorker).to receive(:perform_async).with(params)
      end
  
      it 'must to return successful body content' do
        expect(service).to eq successful_response
        expect(HandleSearchAlbumsWorker).to have_received(:perform_async).with(params).once
      end
    end

    context "withou query param" do
      let(:service) { described_class.call }
      
      before do
        allow(HandleSearchAlbumsWorker).to receive(:perform_async)
      end
  
      it 'must to return successful body content' do
        expect(service).to eq successful_response
        expect(HandleSearchAlbumsWorker).to have_received(:perform_async).once
      end
    end
  end
end