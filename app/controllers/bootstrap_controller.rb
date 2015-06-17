class BootstrapController < ApplicationController
  def up
    ref = params[:ref] || 'stable'

    render 'up.sh', layout: false, locals: {ref: ref}
  end
end
