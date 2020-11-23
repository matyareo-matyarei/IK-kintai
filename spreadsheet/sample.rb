require 'google_drive'
require 'active_support/time'
require 'holiday_japan'

session = GoogleDrive::Session.from_config('config.json')
key = '17uvb27n9d-pobk0kVQy-YwJbXhxpEaOt2RBP0vB2j4M'
sheet = session.spreadsheet_by_key(key).worksheet_by_title('水野雅之')

# 出退勤記録の削除コマンド
## スプレッドシートへの""の上書き
# ***入力されている日付を基準にスプレットシートの入力する箇所を定める***[inputline]
inputline = $attendance.work_days.day + 5

# 出勤(true)の場合／退勤(false)の場合を分岐
if $attendance.in_out
  # 出勤時間を削除
  sheet[inputline, 3] = ""
else
  # 退勤時間を削除
  sheet[inputline, 4] = ""
end

# 勤務場所を削除
sheet[inputline, 8] = ""

# 交通費の入力の削除
sheet[inputline, 10] = ""


sheet.save

# puts Time.parse(sheet[6,1])
# C3セルの情報を取得
# シート側で数値が書き込まれていても文字列が返ってくるので要注意

# C3セルの値や数式を取得
# 配列形式で取得すると「シートに表示されている文字(数値)」が返ってくるが、
# input_valueでは「数式や値そのもの」が返ってくる
# p sheets.input_value("C2")

# 配列形式やinput_valueではシートの値を文字列として取得できるが、
# numeric_valueでは数値として取得することが可能??（数字のみ表示○、計算結果などは×）
# p sheets.numeric_value("C2")
