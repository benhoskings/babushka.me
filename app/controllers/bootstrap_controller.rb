class BootstrapController < ApplicationController
  def up
    ref = params[:ref] || 'stable'

    render action: 'up', layout: false, locals: {ref: ref}
  end
end
