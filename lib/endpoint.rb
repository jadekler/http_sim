module HttpSimulator
  class Endpoint
    attr_reader :method, :path, :default_response
    attr_accessor :requests, :response

    @@supported_methods = ['GET', 'PUT', 'PATCH', 'POST', 'DELETE']

    def initialize(method, path, default_response)
      raise "Unsupported method #{method}" unless @@supported_methods.include? method

      @method = method
      @path = path
      @response = default_response
      @default_response = default_response
      @requests = []
    end

    def add_request(request)
      @requests.push request
    end
  end
end
