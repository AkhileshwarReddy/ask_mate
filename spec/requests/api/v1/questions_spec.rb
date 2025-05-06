require 'rails_helper'

RSpec.describe "Api::V1::Questions", type: :request do
  before { create_list(:question, 30) }

  it "returns paginated questions with default params" do
    get "/api/v1/questions"

    expect(response).to have_http_status(:ok)

    json = JSON.parse(response.body)
    expect(json).to include("success", "data", "message", "meta", "status")
    expect(json["success"]).to be true
    expect(json["data"].size).to eq(Kaminari.config.default_per_page)
    expect(json["meta"]["current_page"]).to eq(1)
    expect(json["meta"]["per_page"]).to eq(Kaminari.config.default_per_page)
    expect(json["meta"]["next_page"]).to eq(2)
    expect(json["meta"]["prev_page"]).to eq(nil)
    expect(json["meta"]["total_pages"]).to eq(2)
  end

  it "returns paginated questions with valid pagination params" do
    get "/api/v1/questions", params: { page: 1, per_page: 20 }
    expect(response).to have_http_status(:ok)

    json = JSON.parse(response.body)
    expect(json).to include("success", "data", "message", "meta", "status")
    expect(json["success"]).to be true
    expect(json["data"].size).to eq(20)
    expect(json["meta"]["current_page"]).to eq(1)
    expect(json["meta"]["per_page"]).to eq(20)
    expect(json["meta"]["next_page"]).to eq(2)
    expect(json["meta"]["prev_page"]).to eq(nil)
    expect(json["meta"]["total_pages"]).to eq(2)
  end

  it "returns empty data for out-of-range page" do
    get "/api/v1/questions", params: { page: 3, per_page: 20 }
    expect(response).to have_http_status(:ok)
    # byebug
    json = JSON.parse(response.body)
    expect(json).to include("success", "data", "message", "meta", "status")
    expect(json["success"]).to be true
    expect(json["data"]).to eq([])
    expect(json["meta"]["current_page"]).to eq(3)
    expect(json["meta"]["per_page"]).to eq(20)
    expect(json["meta"]["next_page"]).to eq(nil)
    expect(json["meta"]["prev_page"]).to eq(nil)
    expect(json["meta"]["total_pages"]).to eq(2)
  end
end
