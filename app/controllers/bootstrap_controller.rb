class BootstrapController < ApplicationController
  def up
    ref = params[:ref] || 'master'

    render action: 'up', layout: false, locals: {ref: ref}
  end
end
