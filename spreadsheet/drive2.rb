require "google_drive"

session = GoogleDrive::Session.from_config("config.json")

# 書き込みたいスプレッドシートを、千束の勤怠に指定する
spreads = session.spreadsheet_by_key("17uvb27n9d-pobk0kVQy-YwJbXhxpEaOt2RBP0vB2j4M")

# "水野雅之"Userのfull_nameと一致するワークシートを取得
worksheet_tittle = @user.full_name
worksheet = spreads.worksheet_by_title(worksheet_tittle)

# 休憩時間は拘束時間が10時間以上なら1:00記入される
# 一度送信してからスプレットシートに反映されるため、こちらの条件分岐は２回目の送信にする
kousoku = Time.parse(worksheet[6,12])
ten = Time.parse("10:00")


if kousoku.hour >= ten.hour
  worksheet[6,5] = "1:00"
else
  worksheet[6,5] = ""
end


# User登録が非常勤(full_partがfalse)の人は土と日・祝日に手当てが入る


# 非常勤の施術者は日報の施術時間を入力



worksheet.save
