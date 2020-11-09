class UsersController < ApplicationController

  def show
    @user = current_user
    @attendances = current_user.attendances.order(id: "DESC")
  end

end
