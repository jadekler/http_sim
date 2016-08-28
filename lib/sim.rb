require 'sinatra'

module HttpSimulator
  class Sim < Sinatra::Base
    set :port, 6565

    def register_endpoint(method: 'GET', path: '/default_endpoint', body: 'Default body')
      @endpoints = [] if @endpoints == nil

      @endpoints.push({method: method, path: path, body: body})
    end

    get '/*' do
      p '*'*80
      p @endpoints
      p '*'*80

      ''

      # if contains_endpoint('GET', request.path)
      #   'boom'
      # end
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
