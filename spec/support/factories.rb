FactoryGirl.define do

#
# These tables are loaded from +seeds.rb+
#
=begin
  factory :store do
    sequence(:name)    { |n| "Store #{n}" }
    sequence(:domain)  { |n| "www.domain-#{n}.com" }
  end

  factory :department do
    name 'Music'
    #sequence(:name)  { |n| "Department #{n}" }
  end

  factory :platform do
    association :department
    sequence(:name)  { |n| "Platform #{n}" }
  end
=end

  factory :item do
    department_id 1
    platform_id 1
    sequence(:title)       { |n| "Title   #{n}" }
    sequence(:creator)     { |n| "Creator #{n}" }
    sequence(:description) { |n| "Description #{n}"}
    release_date Date.tomorrow+1
  end

  factory :product do
    association :item
    store_id 1
    url 'http://site.com/item'
    sequence(:price) { |n| n + 0.99 }
    sequence(:asin)  { |n| "B00NPZI1ZS#{n}" }
  end

end