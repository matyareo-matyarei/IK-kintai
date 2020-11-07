class AttendancesController < ApplicationController
  before_action :authenticate_user!

  def new
    @attendace = Attendance.new
  end

  def create
    @attendace = Attendance.new(attendace_params)
    if @attendace.save
      require "./spreadsheet/drive"

    else
      render :new
    end
  end
  
  private

  def attendace_params
    params.require(:attendance).permit(:work_place_id, :work_days, :in_out, :work_time, :carfare).merge(user_id: current_user.id)

  end
end
