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
end
