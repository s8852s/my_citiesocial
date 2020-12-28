FactoryBot.define do
  factory :sku do
    product { nil }
    spec { "MyString" }
    quantity { 1 }
    deleted_at { "2020-12-26 23:00:58" }
  end
end
