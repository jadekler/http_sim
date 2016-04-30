require 'spec_helper'

describe 'requests' do
  before :each do
    HttpSimulator.reset_endpoints
  end

  after :each do
    HttpSimulator.stop_daemon!
  end

  describe 'getting requests' do
    it 'sets up GET /<endpoint>/requests for each registered endpoint' do
      HttpSimulator.register_endpoint 'POST', '/hi', ''
      HttpSimulator.register_endpoint 'POST', '/bye', ''
      HttpSimulator.run_daemon!(port: 6565)

      resp = HTTParty.get('http://localhost:6565/hi/requests')
      expect(resp.code).to eq 200

      resp = HTTParty.get('http://localhost:6565/bye/requests')
      expect(resp.code).to eq 200
    end

    it 'GET /<endpoint>/requests returns recorded requests' do
      HttpSimulator.register_endpoint 'POST', '/bye', 'byeeeee'
      HttpSimulator.run_daemon!(port: 6565)

      HTTParty.post('http://localhost:6565/bye', :body => 'hello world')

      resp = HTTParty.get('http://localhost:6565/bye/requests')
      expect(resp.code).to eq 200
      expect(resp.body).to include 'hello world'
    end

    xit '.resets returns recorded requests' # TODO
  end

  describe 'resetting requests' do
    xit 'sets up a DELETE /<endpoint>/requests for each registered endpoint' # TODO
    xit 'DELETE /<endpoint>/requests resets recorded requests' # TODO
    xit '.reset_requests reset recorded requests' # TODO
  end
end
