class UsersController < ApplicationController

  def show
    @user = current_user
    @attendances = current_user.attendances.order(id: "DESC")

  end

  def edit
  end

  def update

  end
end
