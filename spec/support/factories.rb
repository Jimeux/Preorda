FactoryGirl.define do

  factory :store do
    name 'TestStore'
    domain 'teststore.com'
  end

  factory :department do
    sequence(:name)  { |n| "Department #{n}" }
  end

  factory :platform do
    association :department
    sequence(:name)  { |n| "Platform #{n}" }
  end

  factory :item do
    association :department
    association :platform
    sequence(:title)       { |n| "Title   #{n}" }
    sequence(:creator)     { |n| "Creator #{n}" }
    sequence(:description) { |n| "Description #{n}"}
    release_date '2014-11-10'
  end

  factory :product do
    association :item
    association :store
    url 'http://site.com/item'
    price 9.99
    asin 'B00NPZI1ZS'
  end

end