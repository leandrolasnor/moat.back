require "rails_helper"

RSpec.describe NotificationChannel, type: [:channel, :request, :controller, :feature] do

  describe "subscription" do
    context "when send correctly connect params" do
      let(:sign_in_response){sign_in(user:{email: 'teste@teste.com', password: '123456'})}
      it "be confirmed" do
        current_user = User.find_by email: sign_in_response[:headers]["uid"]
        stub_connection current_user: current_user
        subscribe
        expect(subscription).to be_confirmed
      end
    end

    context "when send invalid connect params" do
      it "not be confirmed" do
        stub_connection current_user: nil
        subscribe
        expect(subscription).not_to be_confirmed
      end
    end
  end
end