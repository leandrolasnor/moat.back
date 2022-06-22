require 'rails_helper'

RSpec.describe HandleShowAlbumWorker, type: :worker do
  let(:worker) { described_class.new.perform(params) }
  let(:params) { { channel: "channel", id: album.id } }
  let(:album) { create(:album) }
  let(:album_fetched) { {type: 'ALBUM_FETCHED', payload:{ album: album.to_h}} }
  let(:error) { StandardError.new("Some Error") }
  let(:event_error) { {type: '500', payload:{message: 'HTTP 500 Internal Server Error'} } }
  
  context "when there is a success case" do
    before do
      allow(Albums).to receive(:show).with(params)
      allow(ActionCable.server).to receive(:broadcast)
      worker
    end

    it "the Albums module is called once" do
      expect(Albums).to have_received(:show).with(params).once
      expect(ActionCable.server).to have_received(:broadcast).once
    end
  end

  context "when there is a failure case" do
    before do
      allow(Albums).to receive(:show).with(params).and_raise(error)
      allow(Rails.logger).to receive(:error).with(error.inspect)
      allow(ActionCable.server).to receive(:broadcast).with(params[:channel], event_error)
      worker
    end
    
    it "the rescue block will to run" do
      expect(Rails.logger).to have_received(:error).with(error.inspect).once
      expect(ActionCable.server).to have_received(:broadcast).with(params[:channel], event_error).once
    end  
  end
end