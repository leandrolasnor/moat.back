FactoryBot.define do
  factory :album do
    name { Faker::Quotes::Chiquito.expression }
    year { rand(1948..Time.now.year).to_i }
    artist_id { [1,2,3,4,5].sample }
  end
end