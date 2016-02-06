ENV['RACK_ENV'] = 'test'

require "minitest/autorun"
require 'rack/test'

require_relative '../lib/babushka.me.rb'

class BabushkaMeTest < Minitest::Test
  include Rack::Test::Methods

  def app
    BabushkaMe
  end

  def test_response_includes_refspec_header
    get '/up'
    assert_match /[0-9a-f]{7,}/, last_response["X-Refspec"]
  end

  def test_ref_defaults_to_stable
    get '/up'
    assert_match /^ref=stable$/, last_response.body
  end

end
