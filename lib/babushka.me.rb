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

  get '/' do
    "Hello world!"
  end
end
