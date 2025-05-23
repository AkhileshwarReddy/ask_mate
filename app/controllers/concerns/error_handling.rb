class AuthenticationError < StandardError; end

module ErrorHandling
    extend ActiveSupport::Concern

    included do
        rescue_from ActiveRecord::RecordNotFound,       with: :handle_not_found
        rescue_from ActiveRecord::RecordInvalid,        with: :handle_unprocessable_entity
        rescue_from ActionController::ParameterMissing, with: :handle_bad_request
        rescue_from ActiveRecord::StatementInvalid,     with: :handle_internal_server_error 
        rescue_from AuthenticationError,                with: :handle_unauthorized
    end

    private

    def render_success(serializer: nil, message: "", meta: {}, status: :ok)
        data =  block_given? ? yield : serializer.serializable_hash[:data]
        
        render json: {
          success: true,
          data:    data,
          message: message,
          meta:    meta,
          status:  status.to_s
        }, status: status
    end

    def handle_unauthorized(exception)
        render_error(
            errors: exception.message,
            status: :unauthorized
        )
    end

    def render_error(errors:, status: :unprocessable_entity)
        render json: {
            success: false,
            errors: Array(errors),
            status: status.to_s
        }, status: status
    end

    def handle_not_found(exception)
        render_error(
            errors: exception.message,
            status: :not_found
        )
    end

    def handle_bad_request(exception)
        render_error(
            errors: exception.message,
            status: :bad_request
        )
    end

    def handle_unprocessable_entity(exception)
        render_error(
            errors: exception.record.errors.full_messages,
            status: :unprocessable_entity
        )
    end

    def handle_internal_server_error(e)
        byebug
        render_error(
            errors: e.message,
            status: :internal_server_error
        )
    end
end
