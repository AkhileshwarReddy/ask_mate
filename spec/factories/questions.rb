FactoryBot.define do
  factory :question do
    title { Faker::Lorem.sentence(word_count: 4) }
    body { Faker::Lorem.paragraph(sentence_count: 4) }
    status { "open"}
    view_count { 0 }
  end
end
