require 'rails_helper'

RSpec.describe Questions::FetchIndex do
    let(:params) { ActionController::Parameters.new(page: 1, per_page: 5) }
    subject(:service) { described_class.new(params) }

    before { Rails.cache.clear }

    describe "#call" do 
        context "when cache is empty" do
            before { create_list(:question, 15) }

            it "returns a hash with :data and :meta" do
                result = service.call

                expect(result).to be_a(Hash)
                expect(result).to include(:data, :meta)
                expect(result[:data].size).to eq(5)
                expect(result[:meta]).to include(:current_page, :next_page, :prev_page, :total_pages, :per_page)
            end

            it "writes to the cache" do
                key = service.send(:cache_key)
                expect(Rails.cache.read(key)).to be_nil
                service.call
                expect(Rails.cache.read(key)).to be_present
            end
        end

        context "when cache exists" do
            let(:cached) { { data: ["foo"], meta: { current_page: 1, prev_page: 0, next_page: 2, total_pages: 3, per_page: 5} } }

            before { Rails.cache.write(service.send(:cache_key), cached) }

            it "returns the cached payload without querying the DB" do
                expect(Question).to_not receive(:order)
                result = service.call
                expect(result).to eq(cached)
            end
        end
    end
end
