FactoryBot.define do
  factory :order do
    num { "MyString" }
    recipient { "MyString" }
    tel { "MyString" }
    address { "MyString" }
    note { "MyText" }
    user { nil }
    state { "MyString" }
    paid_at { "2021-03-07 21:31:13" }
    transation_id { "MyString" }
  end
end
