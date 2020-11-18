class AttendancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:create, :assist]

  def new
    @attendance = Attendance.new
  end

  def create
    @attendance = Attendance.new(attendance_params)
    if @attendance.save
      $attendance = @attendance
      load 'spreadsheet/attendance.rb'
      @attendances = current_user.attendances.order(id: 'DESC')
    else
      render :new
    end
  end

  def assist
    load 'spreadsheet/assist.rb'
  end

  private

  def attendance_params
    params.require(:attendance).permit(:work_place_id, :work_days, :in_out, :work_time, :carfare).merge(user_id: current_user.id)
  end

  def set_user
    $user = current_user
  end
end
