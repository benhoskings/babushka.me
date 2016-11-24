require "sinatra/base"
require "sinatra/reloader"
require 'bugsnag'

Bugsnag.configure do |config|
  config.api_key = ENV.fetch('BABUSHKA_BUGSNAG_KEY')
  config.project_root = File.dirname(__dir__)
end

class BabushkaMe < Sinatra::Base
  use Bugsnag::Rack
  enable :raise_errors

  configure :development do
    register Sinatra::Reloader
  end

  REFSPEC = `git rev-parse --short HEAD 2>/dev/null`.strip

  before do
    headers "X-Refspec" => REFSPEC
  end

  get '/up' do
    content_type 'text/plain'
    erb :"up.sh", locals: {ref: 'stable'}
  end

  get '/up/:ref' do
    content_type 'text/plain'
    erb :"up.sh", locals: {ref: params[:ref]}
  end

  get("/docs") { redirect("http://babushka.me") }
  get("/rdoc") { redirect("http://www.rubydoc.info/github/benhoskings/babushka") }
  get("/mailing_list") { redirect("http://groups.google.com/group/babushka_app") }
  get(%r{/([0-9a-f]{7,40})}i) { redirect("http://github.com/benhoskings/babushka/commit/#{params[:captures].first}") }

  get('/diagnostics/exception') do
    raise
  end

end
