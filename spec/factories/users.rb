FactoryBot.define do
  factory :user do
    email 'user@lohika.com'
    password 'secret5678'
    admin false
  end

  factory :admin, class: User do
    email 'user@lohika.com'
    password 'secret5678'
    admin true
  end
end
