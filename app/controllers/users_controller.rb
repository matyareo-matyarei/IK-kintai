class UsersController < ApplicationController

  def show
    @user = User.find(current_user.id)
    @attendances = current_user.attendances.order(id: "DESC")

  end

  def edit
  end

  def update

  end
end
