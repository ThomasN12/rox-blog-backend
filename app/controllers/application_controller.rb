class ApplicationController < ActionController::API

  def encode_token(payload)
    JWT.encode(payload, ENV["SECRET_KEY"].to_s)
  end

  def auth_header
    # Authorization: 'Bearer <token>'
    request.headers["Authorization"]
  end

  def decode_token
    return unless auth_header

    token = auth_header.split(" ")[1]
    begin
      JWT.decode(token, ENV["SECRET_KEY"].to_s, true, algorithm: "HS256")
    rescue JWT::DecodeError
      nil
    end
  end

  def token_verified
    return unless decode_token

    begin
      # debugger
      token_confirm = decode_token[0]["token"]
      # is_admin = decode_token[0]["is_admin"]
      @token_data ||= UserToken.find_by_token(token_confirm)
      return nil unless @token_data
      return nil unless @token_data["expired_at"] > Time.zone.now

      @token_data
    rescue
      nil
    end
  end  

  def authorized
    response_failed(:unauthorized, ["Unauthorized"]) unless token_verified
  end

  def response_success(data = nil, message = "")
    render json: { success: true, message:, data: }, status: 200
  end

  def response_failed(status = 200, messages = [])
    errors = messages.map { | msg | { message: msg } }
    render json: { success: false, errors: }, status:
  end

  def serializer_modal(data, serializer)
    ActiveModelSerializers::SerializableResource.new(data, { serializer: })
  end

  def each_serializer_modal(data, each_serializer)
    ActiveModelSerializers::SerializableResource.new(data, { each_serializer: })
  end
  
  def encode_token_user(user)
    token = encode_token({ user_id: user.id, email: user.email, exp: Time.zone.now.to_i + 1.month.to_i })
    # return token
    user_token_params = { 
      user_id: user.id,
      token:,
      expired_at: Time.zone.now + 1.month
    }
    UserToken.create(user_token_params)
    encode_token({ token:, is_admin: false })
  end  

end
