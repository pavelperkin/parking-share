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
end
