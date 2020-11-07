require "google_drive"

session = GoogleDrive::Session.from_config("config.json")

# 書き込みたいスプレッドシートを、千束の勤怠に指定する
spreads = session.spreadsheet_by_key("17uvb27n9d-pobk0kVQy-YwJbXhxpEaOt2RBP0vB2j4M")

# "水野雅之"Userのfull_nameと一致するワークシートを取得
worksheet_tittle = "水野雅之"
worksheet = spreads.worksheet_by_title(worksheet_tittle)

# time = Time.now
# p "#{time.hour} : #{time.min}"

# スプレッドシートへの書き込み
worksheet[6,3] = "10:00"
worksheet[6,4] = "21:00"
worksheet[6,8] = "千束通り"

# 休憩時間は拘束時間が10時間以上なら1:00記入される
# 一度送信してからスプレットシートに反映されるため、こちらの条件分岐は２回目の送信にする
kousoku = Time.parse(worksheet[6,12])
ten = Time.parse("10:00")


if kousoku.hour >= ten.hour
  worksheet[6,5] = "1:00"
else
  worksheet[6,5] = ""
end


# 以下のようにセルを直接指定することも可能
# sheets["B3"] = "年"

# 数式を書き込むことも可能
# sheets["C1"] = nil
# sheets["C2"] = nil
# sheets["C3"] = "11"

# E4セルを起点に複数の配列を書き込む
# array_first = [1, 2, 3, 4, 5]
# array_second = [6, 7, 8, 9, 10]
# sheets.update_cells(4, 5, [array_first, array_second])

# シートの保存
worksheet.save
# puts Time.parse(worksheet[6,1])
# C3セルの情報を取得
# シート側で数値が書き込まれていても文字列が返ってくるので要注意
# [行番号, 列番号]の指定方法と、「C3」のようにセルを直接指定する方法がある
# p sheets["C1"]
# p sheets["C3"]

# C3セルの値や数式を取得
# 配列形式で取得すると「シートに表示されている文字(数値)」が返ってくるが、
# input_valueでは「数式や値そのもの」が返ってくる
# p sheets.input_value("C2")

# 配列形式やinput_valueではシートの値を文字列として取得できるが、
# numeric_valueでは数値として取得することが可能??（数字のみ表示○、計算結果などは×）
# p sheets.numeric_value("C2")