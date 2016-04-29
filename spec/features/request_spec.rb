require 'spec_helper'

describe '/<endpoint>/requests' do
  before :each do
    HttpSimulator.reset_endpoints
  end

  after :each do
    HttpSimulator.stop_daemon!
  end

  it 'sets up a /request endpoint for each registered endpoint' do
    HttpSimulator.register_endpoint 'POST', '/hi', ''
    HttpSimulator.register_endpoint 'POST', '/bye', ''
    HttpSimulator.run_daemon!(port: 6565)

    resp = HTTParty.get('http://localhost:6565/hi/requests')
    expect(resp.code).to eq 200

    resp = HTTParty.get('http://localhost:6565/bye/requests')
    expect(resp.code).to eq 200
  end

  it 'records requests at /requests endpoint' do
    HttpSimulator.register_endpoint 'POST', '/bye', 'byeeeee'
    HttpSimulator.run_daemon!(port: 6565)

    HTTParty.post('http://localhost:6565/bye', :body => 'hello world')

    resp = HTTParty.get('http://localhost:6565/bye/requests')
    expect(resp.code).to eq 200
    expect(resp.body).to include 'hello world'
  end
end
