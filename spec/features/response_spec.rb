require 'spec_helper'

describe 'responses' do
  before :each do
    HttpSimulator.reset_endpoints

    HttpSimulator.register_endpoint 'POST', '/hi', 'this is hi response'
    HttpSimulator.register_endpoint 'POST', '/bye', 'this is bye response'

    HttpSimulator.run_daemon!(port: test_port)
  end

  after :each do
    HttpSimulator.stop_daemon!(port: test_port)
  end

  describe 'getting response' do
    it 'sets up GET /<endpoint>/response for each registered endpoint' do
      resp = get '/hi/response'
      expect(resp.code).to eq 200

      resp = get '/bye/response'
      expect(resp.code).to eq 200
    end

    it 'GET /<endpoint>/response returns response for endpoint' do
      resp = json_get '/hi/response'
      expect(resp.body).to eq 'this is hi response'

      resp = json_get '/bye/response'
      expect(resp.body).to eq 'this is bye response'
    end

    xit '.response returns response for endpoint' # TODO
  end

  describe 'setting response' do
    it 'sets up PUT /<endpoint>/response for each registered endpoint' do
      resp = put '/hi/response', '{}'
      expect(resp.code).to eq 200

      resp = put '/bye/response', '{}'
      expect(resp.code).to eq 200
    end

    it 'PUT /<endpoint>/response alters response for endpoint' do
      resp = json_get '/hi/response'
      expect(resp.body).to eq 'this is hi response'

      put '/hi/response', 'this is some new response'
      resp = json_get '/hi/response'
      expect(resp.body).to eq 'this is some new response'
    end

    xit '.set_response alters response for endpoint' # TODO
  end

  describe 'resetting response' do
    it 'sets up a DELETE /<endpoint>/response for each registered endpoint' do
      resp = delete '/hi/response'
      expect(resp.code).to eq 200

      resp = delete '/bye/response'
      expect(resp.code).to eq 200
    end

    it 'DELETE /<endpoint>/response resets response for endpoint' do
      put '/hi/response', 'this is some new response'
      resp = json_get '/hi/response'
      expect(resp.body).to eq 'this is some new response'

      delete '/hi/response'

      resp = json_get '/hi/response'
      expect(resp.body).to eq 'this is hi response'
    end

    xit '.reset_response resets response for endpoint' # TODO
  end
end
