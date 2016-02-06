require "sinatra/base"
require "sinatra/reloader"

class BabushkaMe < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  REFSPEC = `git rev-parse --short HEAD 2>/dev/null`.strip

  before do
    headers "X-Refspec" => REFSPEC
  end

  get '/up' do
    erb :"up.sh", locals: {ref: 'stable'}
  end

  get '/up/:ref' do
    erb :"up.sh", locals: {ref: params[:ref]}
  end

  get("/docs") { redirect("http://babushka.me") }
  get("/rdoc") { redirect("http://www.rubydoc.info/github/benhoskings/babushka") }
  get("/mailing_list") { redirect("http://groups.google.com/group/babushka_app") }
  get(%r{/([0-9a-f]{7,40})}i) { redirect("http://github.com/benhoskings/babushka/commit/#{params[:captures].first}") }

end
