require 'sinatra'

module HttpSimulator
  class Sim < Sinatra::Base
    set :port, 6565

    def check
      'yep'
    end

    def register_endpoint(method: 'GET', endpoint: '/default_endpoint', body: 'Default body')
    end

    get '/' do
      puts 'Gotcha'
    end
  end
end
