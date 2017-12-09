FactoryBot.define do
  factory :user do
    email "#{Faker::Internet.user_name}@lohika.com"
    password Faker::Crypto.md5
    admin false
  end

  factory :admin, class: User do
    email "#{Faker::Internet.user_name}@lohika.com"
    password Faker::Crypto.md5
    admin true
  end

  factory :profile do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    phone_number Faker::PhoneNumber.cell_phone
    user
  end

  factory :car do
    make Faker::StarWars.vehicle
    model Faker::StarWars.planet
    number Faker::StarWars.droid
    profile
  end

  factory :parking do
    name Faker::StarWars.planet
    rank 1
    order ["asc", "desc"].sample
  end

  factory :parking_place do
    number Faker::Number.number(1)
    parking
    profile_id nil
  end
end
