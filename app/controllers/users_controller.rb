class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @attendances = current_user.attendances.order(id: 'DESC')
  end
end
