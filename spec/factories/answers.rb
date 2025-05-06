FactoryBot.define do
  factory :answer do
    body { "MyText" }
    status { "MyString" }
    question { nil }
  end
end
