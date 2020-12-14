require "./spreadsheet/set"
# require 'google_drive'
# require 'active_support/time'
# session = GoogleDrive::Session.from_config('config.json')

# リモートファイルの取得
# session.files.each do |file|
  # puts file.title
# end

# 書き込みたいスプレッドシートを、千束の勤怠に指定する
# spreads = session.spreadsheet_by_key('17uvb27n9d-pobk0kVQy-YwJbXhxpEaOt2RBP0vB2j4M')

# "水野雅之"Userのfull_nameと一致するワークシートを取得
# worksheet_tittle = '水野雅之'
# sheet = spreads.worksheet_by_title(worksheet_tittle)

spreadsheetset
p @sheet[6,3]


