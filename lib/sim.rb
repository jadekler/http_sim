require 'sinatra'

module HttpSimulator
  class Sim < Sinatra::Base
    set :port, 6565

    def register_endpoint(method: 'GET', endpoint: '/default_endpoint', body: 'Default body')
      @endpoints = [] if @endpoints == nil

      @endpoints.push({method: method, endpoint: endpoint, body: body})
    end

    post '/*' do
      puts '*'*80
      p @endpoints
      puts '*'*80
    end
  end
end
