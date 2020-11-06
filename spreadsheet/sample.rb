require "google_drive"
require "active_support/time"

session = GoogleDrive::Session.from_config("config.json")
key = '17uvb27n9d-pobk0kVQy-YwJbXhxpEaOt2RBP0vB2j4M'
sheet = session.spreadsheet_by_key(key).worksheet_by_title("シート1")

# (1..sheet.num_rows).each do |row|
#   (1..sheet.num_cols).each do |col|
#     p sheet[row, col]
#   end
# end
time = Time.now
sheet[sheet.num_rows + 1, 1] = "#{time.year} 年"
sheet[sheet.num_rows + 1, 1] = "#{time.month} 月"
sheet[sheet.num_rows + 1, 1] = "#{time.day} 日"
sheet[sheet.num_rows + 1, 1] = "#{time.hour} 時"
sheet[sheet.num_rows + 1, 1] = "#{time.min} 分"
sheet[sheet.num_rows + 1, 1] = "#{time.sec} 秒"
p time.sunday? #日曜日か
p time.saturday? #土曜日か

sheet[sheet.num_rows + 1, 1] = "#{time.wday} 曜日を数字で取得"
# 足し算は+3600なら3600秒（１時間）


sheet.save
