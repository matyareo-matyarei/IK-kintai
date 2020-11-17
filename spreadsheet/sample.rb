require "google_drive"
require "active_support/time"
require 'holiday_japan'


session = GoogleDrive::Session.from_config("config.json")
key = '17uvb27n9d-pobk0kVQy-YwJbXhxpEaOt2RBP0vB2j4M'
sheet = session.spreadsheet_by_key(key).worksheet_by_title("水野雅之")

eight = Time.parse("8:00") # 8時間の値eight
# 手当て入力
(6..sheet.num_rows).each do |row| #セルの行で値が入っているところまで
  begin
    kousoku = Time.parse(sheet[row,12]) #拘束時間の値=kousoku
    day = Date.parse(sheet[row,1]) #各行の日付
    if sheet[row,3].present? && sheet[row,4].present? #出勤退勤入力がされていたら
      if day.sunday? || day.national_holiday?         #日曜又は祝日なら
        if kousoku.hour >= eight.hour #8h以上なら１日手当て、それ以下は半日手当て
          sheet[row,11] = 800
        else
          sheet[row,11] = 400
        end
      elsif day.saturday? #土曜
        if kousoku.hour >= eight.hour 
          sheet[row,11] = 400
        else
          sheet[row,11] = 200
        end
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




