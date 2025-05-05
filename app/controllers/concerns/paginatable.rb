module Paginatable
    extend ActiveSupport::Concern

    private

    def pagination_params
        {
            page:       params.fetch(:page, 1).to_i,
            per_page:   params.fetch(:per_page, Kaminari.config.default_per_page).to_i
        }
    end

    def paginate(scope)
        scope.page(pagination_params[:page]).per(pagination_params[:per_page])
    end

    def pagination_meta(scope)
        {
            current_page: scope.current_page,
            next_page:    scope.next_page,
            prev_page:    scope.prev_page,
            total_pages:  scope.total_pages,
            total_count:  scope.total_count,
            per_page:     scope.limit_value
        }
    end
end