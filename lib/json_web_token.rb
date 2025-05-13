module JsonWebToken
    SECRET_KEY = Rails.application.credentials.dig(:jwt, :secret_key) || ENV['JWT_SECRET_KEY']

    def self.encode(user, exp=1.hour.from_now)
        payload = { user: user, exp: exp.to_i }
        JWT.encode(payload, SECRET_KEY, 'HS256')
    end

    def self.decode(token)
        body = JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')
        HashWithIndifferentAccess.new(body&.first)
    rescue JWT::ExpiredSignature
        raise AuthenticationError, 'Token has expired'
    rescue JWT::DecodeError
        raise AuthenticationError, 'Invalid token'
    end
end
