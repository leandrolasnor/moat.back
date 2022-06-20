require 'rails_helper'

RSpec.describe Album, type: :model do
  subject(:album) { create(:album, artist_id: 5) }

  it 'must have validate_presence_of' do
    expect(album).to validate_presence_of(:name)  
    expect(album).to validate_presence_of(:artist_id)
    expect(album).to validate_presence_of(:year)
  end

  it 'must have validate_numericality_of' do
    expect(subject).to validate_numericality_of(:year).is_greater_than_or_equal_to(1948).only_integer
  end

  context "Moat::" do
    context "Api::" do
      context "Album::" do
        before do
          allow(album).to receive(:artist).and_return({id:5, twitter:"@ladygaga", name:"Lady Gaga"})
        end

        it 'must can get the associate artist' do
          expect(album.artist[:id]).to eq album[:artist_id]
        end
      end
    end
  end
end