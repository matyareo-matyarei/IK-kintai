class AttendancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:create, :assist, :destroy]

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

  def line
    load 'spreadsheet/line.rb'
    redirect_to root_path
  end
  
  def destroy
    @attendance = Attendance.find(params[:id])
    $attendance = @attendance
    load 'spreadsheet/destroy.rb'
    @attendance.destroy if current_user.id == @attendance.user_id
    redirect_to users_show_path
  end

  private

  def attendance_params
    params.require(:attendance).permit(:work_place_id, :work_days, :in_out, :work_time, :carfare, :remarks).merge(user_id: current_user.id)
  end

  def set_user
    $user = current_user
  end
end
