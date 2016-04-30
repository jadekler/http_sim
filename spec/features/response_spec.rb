require 'spec_helper'

describe 'responses' do
  before :each do
    HttpSimulator.reset_endpoints
  end

  after :each do
    HttpSimulator.stop_daemon!
  end

  describe 'getting response' do
    it 'sets up GET /<endpoint>/response for each registered endpoint' do
      HttpSimulator.register_endpoint 'POST', '/hi', ''
      HttpSimulator.register_endpoint 'POST', '/bye', ''
      HttpSimulator.run_daemon!(port: 6565)

      resp = HTTParty.get('http://localhost:6565/hi/response')
      expect(resp.code).to eq 200

      resp = HTTParty.get('http://localhost:6565/bye/response')
      expect(resp.code).to eq 200
    end

    xit 'GET /<endpoint>/response returns response for endpoint' # TODO
    xit '.response returns response for endpoint' # TODO
  end

  describe 'setting response' do
    xit 'sets up PUT /<endpoint>/response for each registered endpoint' # TODO
    xit 'PUT /<endpoint>/response alters response for endpoint' # TODO
    xit '.set_response alters response for endpoint' # TODO
  end

  describe 'resetting response' do
    xit 'sets up a DELETE /<endpoint>/response for each registered endpoint' # TODO
    xit 'DELETE /<endpoint>/response resets response for endpoint' # TODO
    xit '.reset_response resets response for endpoint' # TODO
  end
end
