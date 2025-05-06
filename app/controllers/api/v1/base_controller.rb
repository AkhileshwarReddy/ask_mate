module Api
    module V1
        class BaseController < ApplicationController
            include ErrorHandling
            include Paginatable
            include Cacheable
        end
    end
end
