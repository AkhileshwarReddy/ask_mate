module Api
    module V1
        class UsersController < BaseController
            skip_before_action :authenticate_request!, only: [:create]

            def create
                user = User.create!(user_params)
                token = JsonWebToken.encode(user_id: user.id)

                render_success(message: 'User created successfully', status: :created) do
                    {
                        token: token,
                        user: UserSerializer.new(user).serializable_hash[:data]
                    }
                end
            end

            private

            def user_params
                params.require(:user).permit(:email, :password, :password_confirmation)
            end
        end
    end
end