require 'rails_helper'

RSpec.describe Question, type: :model do
  subject { build(:question) }

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:status) }
    it { should validate_length_of(:title).is_at_least(10) }
    it { should validate_length_of(:title).is_at_most(150) }
    it { should validate_length_of(:body).is_at_least(50) }
    it { should validate_length_of(:body).is_at_most(1000) }
    it { should validate_inclusion_of(:status).in_array(Question::STATUSES) }
  end

  describe 'defaults' do
    context "for a new record" do
      let(:question) { build(:question) }

      it "status to 'open'" do
        expect(question.status).to eq("open")
      end

      it "view_count to 0" do
        expect(question.view_count).to eq(0)
      end
    end

    context "after persisting" do
      let(:question) { create(:question) }

      it "status to 'open'" do
        expect(question.status).to eq("open")
      end

      it "view_count to 0" do
        expect(question.view_count).to eq(0)
      end
    end
  end

  describe "factory" do
    it "has a valid factory" do
      expect(build(:question)).to be_valid
    end
  end
end
