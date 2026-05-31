module RequestHelpers
  def auth_headers_for(user)
    token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
    { 'Authorization' => "Bearer #{token}" }
  end

  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end
