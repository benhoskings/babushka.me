class ApplicationController < ActionController::Base
  layout 'application'

  before_filter {
    headers['X-Refspec'] = BabushkaMe::REFSPEC
  }
end
