require "google_drive"
require "active_support/time"
t = Time.now
session = GoogleDrive::Session.from_config("config.json")
# 書き込みたいスプレッドシートを、千束の勤怠に指定する
spreads = session.spreadsheet_by_key("17uvb27n9d-pobk0kVQy-YwJbXhxpEaOt2RBP0vB2j4M")

# "水野雅之"Userのfull_nameと一致するワークシートを取得
worksheet_tittle = "水野雅之"
worksheet = spreads.worksheet_by_title(worksheet_tittle)

worksheet[7,7] = "0:120"
worksheet[8,3] = "#{t.strftime("%H:%M")}"

worksheet.save
# C3セルの値や数式を取得
# 配列形式で取得すると「シートに表示されている文字(数値)」が返ってくるが、
# input_valueでは「数式や値そのもの」が返ってくる


