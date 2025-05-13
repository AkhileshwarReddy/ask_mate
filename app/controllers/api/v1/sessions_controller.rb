module Api
    module V1
        class SessionsController < BaseController
            skip_before_action :authenticate_request!, only: [:create]

            def create
                user = User.find_by(email: params[:email])

                if user&.authenticate(params[:password])
                    render_success(message: 'Login successful') do
                        { token: JsonWebToken.encode(user_id: user.id) }
                    end
                else
                    raise AuthenticationError, 'Invalid email or password'
                end
            end
        end
    end
end
