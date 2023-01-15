FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    published { 
      random = rand(0..1)
      random == 0 ? false : true
     }
    user
  end
end
