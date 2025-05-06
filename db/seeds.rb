# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb
require 'faker'

records = 100_000.times.map do
  {
    title:      Faker::Lorem.sentence(word_count: 4),
    body:       Faker::Lorem.paragraph(sentence_count: 2),
    status:     "open",
    view_count: 0,
    created_at: Time.current,
    updated_at: Time.current
  }
end

Question.insert_all(records)
