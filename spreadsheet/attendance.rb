require 'google_drive'

session = GoogleDrive::Session.from_config('config.json')
# 書き込みたいスプレッドシートを、[$user.affiliation_id.name]で登録している所属院で入力する勤怠を指定する（浅草:2、 千束:3、 日暮里:4、 本部:5）

case $user.affiliation_id
when 2 # 浅草
  spreads = session.spreadsheet_by_key('1c7my0A20BFbcG9hC62MQr1TkwEYj2wjLPeSa7BUio2Q')
when 3 # 千束
  spreads = session.spreadsheet_by_key('1DgfB3Ayrk0QA7VUqeTO3P0aoL1pwgZKCPsnWmtHjLH8')
when 4 # 日暮里
  spreads = session.spreadsheet_by_key('1_cLUUjCG-M16FvS9I_s9m7L6khCr4IjWNWmRc75zFZg')
when 5 # 本部
  spreads = session.spreadsheet_by_key('1gKlozDb0P8VSYQw2wsR11JPgCtgVvvr-sbHvl45ShhI')
end
# [1DgfB3Ayrk0QA7VUqeTO3P0aoL1pwgZKCPsnWmtHjLH8]千束11月の勤怠
# [1c7my0A20BFbcG9hC62MQr1TkwEYj2wjLPeSa7BUio2Q]浅草11月の勤怠
# [1_cLUUjCG-M16FvS9I_s9m7L6khCr4IjWNWmRc75zFZg]日暮里11月の勤怠
# [1gKlozDb0P8VSYQw2wsR11JPgCtgVvvr-sbHvl45ShhI]本部11月の勤怠

# Userのfull_nameと一致するワークシートを取得
sheet_tittle = $user.full_name
sheet = spreads.worksheet_by_title(sheet_tittle)

## スプレッドシートへの書き込み
# ***入力されている日付を基準にスプレットシートの入力する箇所を定める***[inputline]
inputline = $attendance.work_days.day + 5
inputtime = $attendance.work_time

# 出勤(true)の場合／退勤(false)の場合を分岐
if $attendance.in_out
  # 出勤時間入力
  sheet[inputline, 3] = "#{inputtime.strftime('%H:%M')} "
else
  # 退勤時間入力
  sheet[inputline, 4] = "#{inputtime.strftime('%H:%M')} "
end

# 勤務場所を入力
sheet[inputline, 8] = WorkPlace.find($attendance.work_place_id).name.to_s

# 交通費入力（あれば）
sheet[inputline, 10] = $attendance.carfare.to_s if $attendance.carfare.present?

# 備考欄入力（あれば）
if $user.full_part #常勤なら
  sheet[inputline, 17] = $attendance.remarks.to_s if $attendance.remarks.present?
else #非常勤なら
  sheet[inputline, 16] = $attendance.remarks.to_s if $attendance.remarks.present?
end

# シートの保存
sheet.save
