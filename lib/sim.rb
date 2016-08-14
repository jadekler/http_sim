require 'sinatra'

module HttpSimulator
  class Sim < Sinatra::Base
    def initialize(endpoints)
      @endpoints = endpoints
    end

    get '/' do
      puts 'Gotcha'
    end
  end
end
