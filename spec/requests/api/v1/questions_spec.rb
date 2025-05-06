require 'rails_helper'

RSpec.describe "Api::V1::Questions", type: :request do
  describe "GET /api/v1/questions" do
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

  describe "GET /api/v1/questions/:id" do
    let!(:question) { create(:question) }

    it "returns question data with valid params" do
      get "/api/v1/questions/#{question.id}"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["success"]).to be true
      expect(json["data"]).to be_a(Hash)
      expect(json["meta"]).to be_a(Hash)
      expect(json["data"]["id"].to_i).to eq(question.id)
    end

    it "returns 404 response with invalid params" do
      get "/api/v1/questions/999999"

      expect(response).to have_http_status(:not_found)
      
      json = JSON.parse(response.body)

      expect(json["success"]).to be false
      expect(json["errors"].size).to eq(1)
      expect(json["status"]).to eq("not_found")
    end
  end
end
