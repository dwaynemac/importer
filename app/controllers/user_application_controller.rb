class UserApplicationController < ApplicationController
  before_filter :authorize_user!

  private

  def authorize_user!
    unless current_user.admin?
      flash[:error] = "unauthorized access"
      redirect_to home_path
      false
    end
  end
end
