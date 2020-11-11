require "google_drive"
require "active_support/time"

session = GoogleDrive::Session.from_config("config.json")
key = '17uvb27n9d-pobk0kVQy-YwJbXhxpEaOt2RBP0vB2j4M'
sheet = session.spreadsheet_by_key(key).worksheet_by_title("水野雅之")

# 手当て入力
(6..sheet.num_rows).each do |row| #セルの行で値が入っているところまで
  begin
    if Time.parse(sheet[row,1]).sunday?
      sheet[row,11] = 800
    elsif Time.parse(sheet[row,1]).saturday?
      sheet[row,11] = 400
    else
      puts sheet[row,1]
    end
    rescue => e
    puts e.message
  end
end

sheet.save
# p time.sunday? #日曜日か
# p time.saturday? #土曜日か

# sheet[sheet.num_rows + 1, 1] = "#{time.wday} 曜日を数字で取得"



