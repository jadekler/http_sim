require 'spec_helper'

describe 'requests' do
  before :each do
    HttpSimulator.reset_endpoints

    HttpSimulator.register_endpoint 'POST', '/hello', 'jan'
    HttpSimulator.register_endpoint 'POST', '/world', 'van riebeck'

    HttpSimulator.run_daemon!(port: test_port)
  end

  after :each do
    HttpSimulator.stop_daemon!(port: test_port)
  end

  describe 'getting requests' do
    it 'sets up GET /<endpoint>/requests for each registered endpoint' do
      resp = get '/hello/requests'
      expect(resp.code).to eq 200

      resp = get '/world/requests'
      expect(resp.code).to eq 200
    end

    it 'GET /<endpoint>/requests returns recorded requests' do
      post '/world', 'hello world'
      resp = json_get '/world/requests'
      expect(resp.code).to eq 200
      expect(resp.body).to eq '["hello world"]'
    end

    xit '.resets returns recorded requests' # TODO
  end

  describe 'resetting requests' do
    xit 'sets up a DELETE /<endpoint>/requests for each registered endpoint' # TODO
    xit 'DELETE /<endpoint>/requests resets recorded requests' # TODO
    xit '.reset_requests reset recorded requests' # TODO
  end
end
