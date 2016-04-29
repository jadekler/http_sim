require 'spec_helper'

describe '/<endpoint>/response' do
  before :each do
    HttpSimulator.reset_endpoints
  end

  after :each do
    Process.kill('SIGKILL', @@pid)
  end

  it 'sets up a /response endpoint for each registered endpoint' do
    HttpSimulator.register_endpoint 'POST', '/hi', ''
    HttpSimulator.register_endpoint 'POST', '/bye', ''

    start_simulator

    resp = HTTParty.get('http://localhost:6565/hi/response')
    expect(resp.code).to eq 200

    resp = HTTParty.get('http://localhost:6565/bye/response')
    expect(resp.code).to eq 200
  end
end
