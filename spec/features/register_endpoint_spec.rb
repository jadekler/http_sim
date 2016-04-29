require 'spec_helper'

describe '/<endpoint>' do
  before :each do
    HttpSimulator.reset_endpoints
  end

  after :each do
    HttpSimulator.stop_daemon!
  end

  it 'sets up an endpoint for each registered endpoint' do
    HttpSimulator.register_endpoint 'GET', '/foo', ''
    HttpSimulator.register_endpoint 'POST', '/bar', ''
    HttpSimulator.run_daemon!(port: 6565)

    resp = HTTParty.get('http://localhost:6565/foo')
    expect(resp.code).to eq 200

    resp = HTTParty.post('http://localhost:6565/bar', :body => '')
    expect(resp.code).to eq 200
  end
end
