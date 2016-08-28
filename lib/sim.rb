require 'sinatra'

module HttpSimulator
  class Sim < Sinatra::Base
    set :port, 6565

    def self.endpoints(endpoints = nil)
      return @endpoints if @endpoints
      @endpoints = endpoints
    end

    get '/*' do
      p '*'*80
      p @endpoints
      p self.class.endpoints
      p '*'*80

      if contains_endpoint('GET', request.path)
        'boom'
      end

      'hey'
    end

    post '/*' do
      # if contains_endpoint('GET', request.path)
      #   'bam'
      # end
    end

    private

    def contains_endpoint(method, path)
      @endpoints.each do |endpoint|
        if endpoint.method == method && endpoint.path == path
          return true
        end
      end

      false
    end

    def get_endpoint

    end
  end
end
