module Beanstream

  class BeanstreamException < StandardError
    attr_reader :code, :category, :message, :http_status_code
    def initialize(code=nil, category=nil, message=nil, http_status_code=nil)
      @code = code
      @category = category
      @message = message
      @http_status_code = http_status_code
    end
  end
  
  
  class BusinessRuleException < BeanstreamException
    def initialize(code, category, message, http_status_code)
      super(code, category, message, http_status_code)
    end
  end
  
  class UnauthorizedException < BeanstreamException
    def initialize(code, category, message, http_status_code)
      super(code, category, message, http_status_code)
    end
  end
  
  class ForbiddenException < BeanstreamException
    def initialize(code, category, message, http_status_code)
      super(code, category, message, http_status_code)
    end
  end
  
  class InvalidRequestException < BeanstreamException
    def initialize(code, category, message, http_status_code)
      super(code, category, message, http_status_code)
    end
  end
  
  class InternalServerException < BeanstreamException
    def initialize(code, category, message, http_status_code)
      super(code, category, message, http_status_code)
    end
  end
  
end