class ErrorsController < ApplicationController
    before_action :error_info
    
    def show
        render "/errors/#{status_code.to_s}", status: status_code, layout: false
    end

    private

    def error_info
        @error = {}
    end
    
    protected
    
    def status_code
        params[:code] || 500
    end
end
