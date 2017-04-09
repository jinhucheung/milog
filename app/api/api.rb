class API < Grape::API
  format :json
  helpers V1::Helpers

  rescue_from ActiveRecord::RecordNotFound do
    rack_response({'message' => '404 Not found'}.to_json, 404)
  end

  mount V1::Users
end
