require 'rails_helper'


RSpec.describe Api::UserController do

  describe "Register new User", type: :request  do
    before do
      @json_user = { email: 'user@user.com', password: 'demo' }
      #post '/api/user/register', params: { user: { :email => 'user2@user2.com', :password => 'demo' } }
    end

    it "returns http success" do
      post '/api/user/register', params: { user:  @json_user }
      expect(response).to have_http_status(:success)
    end

    it "returns http bad_request" do
      @user1 = create(:user, email: 'user1@user1.com', password: 'demo')
      post '/api/user/register', params: { user: @user1.as_json(only: [:email, :password]) }
      expect(response).to have_http_status(:bad_request)
    end

    it "JSON body response contains :token & :email keys" do
      post '/api/user/register', params: { user:  @json_user }
      json_response = JSON.parse(response.body)
      expect(json_response.keys.map(&:to_sym)).to match_array([:token, :email])
    end

  end


  describe "Login", type: :request  do
     before do
       @user1 = create(:user, email: 'user@user.com', password: 'demo')
     end

     it "returns http success" do
       post '/api/user/login', params: { user: @user1.as_json(only: [:email, :password]) }
       expect(response).to have_http_status(:success)
     end

     it "returns http bad_request" do
       post '/api/user/login', params: { user: { :email => 'user2@user2.com', :password => 'demo' } }
       expect(response).to have_http_status(:bad_request)
     end

     it "JSON body response contains :token & :email keys" do
       post '/api/user/login', params: { user: @user1.as_json(only: [:email, :password]) }
       json_response = JSON.parse(response.body)
       expect(json_response.keys.map(&:to_sym)).to match_array([:token, :email])
     end
  end
end
