require "rails_helper"
require 'json'

RSpec.describe ApplicationCable::Connection, type: [:channel, :request, :controller, :feature] do

  context "must be connected" do
    let(:headers){get_headers}
    it "when send connection params" do
      connect "/cable?uid="+headers["uid"]+"&client="+headers["client"]+"&access_token="+headers["access-token"]
      expect(connection.current_user).to eq User.find(headers["uid"])
    end
  end

  context "must be disconected" do
    it "when connect was reject" do
      expect { connect "/cable" }.to have_rejected_connection
    end
  end

end