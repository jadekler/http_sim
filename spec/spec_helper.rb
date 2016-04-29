require 'httparty'

require_relative '../lib/http_sim'

RSpec.configure do |c|
  c.order = :random
  c.default_formatter = 'doc'
end
