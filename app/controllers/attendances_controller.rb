class AttendancesController < ApplicationController
  before_action :authenticate_user!

  def new
    @attendace = Attendance.new
  end

  def create
    @attendace = Attendance.new(attendace_params)
    if @attendace.save
      
    else
      render :new
    end
  end
  
  private

  def attendace_params

  end
end
