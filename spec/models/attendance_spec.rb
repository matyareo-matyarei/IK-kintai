require 'rails_helper'
RSpec.describe Attendance, type: :model do
  before do
    @attendance = FactoryBot.build(:attendance)
  end


  describe '出退勤情報登録' do
    context '出退勤の登録がうまくいく時' do
      it 'work_place_id]と[work_days]、[password_confirmation]、[in_out]、[work_time]が存在していれば登録できる' do
        expect(@attendance).to be_valid
      end
      it 'carfare]が空でも登録できる' do
        @attendance.carfare = nil
        expect(@attendance).to be_valid
      end
    end

    context '出退勤の登録がうまくいかない時' do
      it 'work_place_id]が空だと登録できない' do
        @attendance.work_place_id = nil
        @attendance.valid?
        expect(@attendance.errors.full_messages).to include("勤務場所を入力してください")
        end
        it 'work_place_id]が1だと登録できない' do
          @attendance.work_place_id = 1
          @attendance.valid?
          expect(@attendance.errors.full_messages).to include("勤務場所を選んでください")
          end
      it 'work_days]が空だと登録できない' do
        @attendance.work_days = nil
        @attendance.valid?
        expect(@attendance.errors.full_messages).to include("勤務日を入力してください")
      end
      it 'in_out]が空だと登録できない' do
        @attendance.in_out = nil
        @attendance.valid?
        expect(@attendance.errors.full_messages).to include("出勤／退勤を選んでください")
      end
      it 'work_time]が空だと登録できない' do
        @attendance.work_time = nil
        @attendance.valid?
        expect(@attendance.errors.full_messages).to include("時刻を入力してください")
      end
      it 'carfare]が全角数字だと登録できない' do
        @attendance.carfare = '３００'
        @attendance.valid?
        expect(@attendance.errors.full_messages).to include("交通費は半角数字で入力してください")
      end

    end

  end
end
