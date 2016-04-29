require 'spec_helper'

describe '/<endpoint>' do
  before :each do
    HttpSimulator.reset_endpoints
  end

  after :each do
    Process.kill('SIGKILL', @@pid)
  end

  it 'sets up an endpoint for each registered endpoint' do
    HttpSimulator.register_endpoint 'GET', '/hi', ''
    HttpSimulator.register_endpoint 'POST', '/bye', ''

    start_simulator

    resp = HTTParty.get('http://localhost:6565/hi')
    expect(resp.code).to eq 200

    resp = HTTParty.post('http://localhost:6565/bye', :body => '')
    expect(resp.code).to eq 200
  end
end
