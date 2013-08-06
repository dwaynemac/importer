class HomeController < ApplicationController
  skip_before_filter :authorize_user!

  def show
  end
end

