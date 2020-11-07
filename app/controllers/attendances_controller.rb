class AttendancesController < ApplicationController
  before_action :authenticate_user!

  def new
    @attendance = Attendance.new
  end

  def create
    @attendance = Attendance.new(attendance_params)
    if @attendance.save
      $user = User.find(current_user.id)
      $attendance = @attendance
      load "spreadsheet/drive.rb"

    else
      render :new
    end
  end
  
  private

  def attendance_params
    params.require(:attendance).permit(:work_place_id, :work_days, :in_out, :work_time, :carfare).merge(user_id: current_user.id)

  end
end
