module Api
    module V1
        class BaseController < ApplicationController
            include ErrorHandling
            include Paginatable
        end
    end
end
