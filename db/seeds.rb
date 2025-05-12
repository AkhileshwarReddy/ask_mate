# db/seeds.rb
require 'faker'
Thread.abort_on_exception = true

# ─── Configuration ────────────────────────────────────────────────────────────
QUESTION_COUNT       = 100_000
QUESTION_BATCH_SIZE  =   5_000
ANSWER_BATCH_SIZE    =   5_000
THREAD_COUNT         =      6

# A small set of sample tags
TAG_NAMES = %w[
  Ruby Rails JavaScript Python API Performance Testing DevOps Security Database
].freeze
# ───────────────────────────────────────────────────────────────────────────────

# Helper to parallelize batch work
def parallelize(slices, threads: THREAD_COUNT)
  queue = Queue.new
  slices.each { |slice| queue << slice }

  workers = threads.times.map do
    Thread.new do
      loop do
        slice = begin
                  queue.pop(true)
                rescue ThreadError
                  break
                end

        ActiveRecord::Base.connection_pool.with_connection do
          yield(slice)
        end
      end
    end
  end

  workers.each(&:join)
end

puts "🗑 Clearing out old data…"
Tag.delete_all
Tagging.delete_all if defined?(Tagging)
Answer.delete_all
Question.delete_all

# ─── 1. Tags ───────────────────────────────────────────────────────────────────
puts "📑 Seeding Tags…"
now = Time.current
tag_records = TAG_NAMES.map { |name| { name: name, created_at: now, updated_at: now } }
Tag.insert_all(tag_records)
tag_ids = Tag.pluck(:id)
puts "   ✅ Created #{tag_ids.size} tags"

# ─── 2. Questions ─────────────────────────────────────────────────────────────
puts "❓ Seeding #{QUESTION_COUNT} Questions in parallel (batch size #{QUESTION_BATCH_SIZE})…"
question_slices = (1..QUESTION_COUNT).to_a.each_slice(QUESTION_BATCH_SIZE).to_a

parallelize(question_slices) do |_slice|
  timestamp = Time.current
  records = Array.new(_slice.size) do
    {
      title:       Faker::Lorem.sentence(word_count: 4),
      body:        Faker::Lorem.paragraph(sentence_count: 2),
      status:      "open",
      view_count:  rand(0..1000),
      created_at:  timestamp,
      updated_at:  timestamp
    }
  end
  Question.insert_all(records)
end

puts "   ✅ Questions seeded: #{Question.count}"

# ─── 3. Answers ───────────────────────────────────────────────────────────────
puts "💬 Seeding Answers in parallel (1–5 per question)…"
question_ids    = Question.pluck(:id)
answer_slices   = question_ids.each_slice(ANSWER_BATCH_SIZE).to_a

parallelize(answer_slices) do |qids|
  timestamp = Time.current
  rows = qids.flat_map do |qid|
    rand(1..5).times.map do
      {
        question_id:  qid,
        body:         Faker::Lorem.sentence(word_count: 8),
        created_at:   timestamp,
        updated_at:   timestamp
      }
    end
  end
  Answer.insert_all(rows) if rows.any?
end

puts "   ✅ Answers seeded: #{Answer.count}"

# ─── 4. Taggings ──────────────────────────────────────────────────────────────
if defined?(Tagging)
  puts "🏷 Seeding Taggings in parallel (1–4 tags per question)…"
  tagging_slices = question_ids.each_slice(QUESTION_BATCH_SIZE).to_a

  parallelize(tagging_slices) do |qids|
    timestamp = Time.current
    rows = qids.flat_map do |qid|
      tag_ids.sample(rand(1..4)).map do |tid|
        {
          question_id: qid,
          tag_id:      tid,
          created_at:  timestamp,
          updated_at:  timestamp
        }
      end
    end
    Tagging.insert_all(rows) if rows.any?
  end

  puts "   ✅ Taggings seeded: #{Tagging.count}"
end

puts "🎉 Seeding complete!"
