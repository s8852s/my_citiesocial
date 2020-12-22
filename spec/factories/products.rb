FactoryBot.define do
  factory :product do
    name { "MyString" }
    vendor { nil }
    price { "9.99" }
    sell_price { "9.99" }
    on_sell { false }
    code { "MyString" }
    deleted_at { "2020-12-22 02:05:54" }
  end
end
