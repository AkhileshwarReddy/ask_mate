module Authenticatable
    extend ActiveSupport::Concern

    included do
        before_action :authenticate_request!
        
        attr_reader :current_user
    end

    private

    def authenticate_request!
        header = request.headers['Authorization']
        token = header&.split(' ')&.last
        raise AuthenticationError, 'Missing token' unless token

        decoded = JsonWebToken.decode(token)
        @current_user = User.find(decoded[:user][:user_id])
    end
end