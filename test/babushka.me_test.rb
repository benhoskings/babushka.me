ENV['RACK_ENV'] = 'test'
ENV['BABUSHKA_BUGSNAG_KEY'] = 'test'

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

  def test_served_as_utf8_plain_text
    get '/up'
    assert_equal "text/plain;charset=utf-8", last_response["Content-Type"]
    get '/up/custom'
    assert_equal "text/plain;charset=utf-8", last_response["Content-Type"]
  end

  def test_ref_defaults_to_stable
    get '/up'
    assert_match /^ref=stable$/, last_response.body
  end

  def test_ref_can_be_customised
    get '/up/master'
    refute_match /^ref=stable$/, last_response.body
    assert_match /^ref=master$/, last_response.body
  end

  def test_redirect_to_docs
    get("/docs")
    assert last_response.redirect?
    assert_equal "http://babushka.me", last_response["Location"]
  end
  def test_redirect_to_rdoc
    get("/rdoc")
    assert last_response.redirect?
    assert_equal "http://www.rubydoc.info/github/benhoskings/babushka", last_response["Location"]
  end
  def test_redirect_to_mailing_list
    get("/mailing_list")
    assert last_response.redirect?
    assert_equal "http://groups.google.com/group/babushka_app", last_response["Location"]
  end

  def test_redirect_to_ref
    get("/f007e2c")
    assert last_response.redirect?
    assert_equal "http://github.com/benhoskings/babushka/commit/f007e2c", last_response["Location"]
  end

end
