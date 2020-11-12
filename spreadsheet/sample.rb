require "google_drive"
require "active_support/time"
require 'holiday_japan'


session = GoogleDrive::Session.from_config("config.json")
key = '17uvb27n9d-pobk0kVQy-YwJbXhxpEaOt2RBP0vB2j4M'
sheet = session.spreadsheet_by_key(key).worksheet_by_title("水野雅之")

# 手当て入力
(6..sheet.num_rows).each do |row| #セルの行で値が入っているところまで
  begin
    if sheet[row,3].present? && sheet[row,4].present? #出勤退勤入力がされていたら
      if Date.parse(sheet[row,1]).sunday?
        sheet[row,11] = 800
      elsif Date.parse(sheet[row,1]).national_holiday?
        sheet[row,11] = 800
      elsif Date.parse(sheet[row,1]).saturday?
        sheet[row,11] = 400
      else
        sheet[row,11] = "" #土日祝日じゃない
      end
    else
      sheet[row,11] = "" # 出退勤入ってない
    end
  rescue => e
    puts e.message
  end
end


sheet.save




