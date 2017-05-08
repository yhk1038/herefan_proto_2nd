class ErrorsController < ApplicationController
    before_action :error_info
    layout '/errors/layout'
    
    def not_found
        @error[:code] = 404
        
        render :status => @error[:code]
    end
    
    def unacceptable
        @error[:code] = 422
        
        render :status => @error[:code]
    end
    
    def internal_error
        @error[:code] = 500
        
        render :status => @error[:code]
    end

    private

    def error_info
        @error = {}
    end
end
