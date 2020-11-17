  require "google_drive"

  session = GoogleDrive::Session.from_config("config.json")
  # 書き込みたいスプレッドシートを、[$user.affiliation_id.name]で登録している所属院で入力する勤怠を指定する（浅草:2、 千束:3、 日暮里:4、 本部:5）


  case $user.affiliation_id
  when 2 # 浅草
    spreads = session.spreadsheet_by_key("1Hy528GhW6XYnoa6KvcfaKyAn98QF9nYVIdFBL-BRJdw")
  when 3 # 千束
    spreads = session.spreadsheet_by_key("17uvb27n9d-pobk0kVQy-YwJbXhxpEaOt2RBP0vB2j4M")
  when 4 # 日暮里
    spreads = session.spreadsheet_by_key("10s6PURZRWmX1GC8Fg9eUGk208_GQlX49K3wcjjlUYQ0")
  when 5 # 本部
    spreads = session.spreadsheet_by_key("17u4Ak5YEMLAqW3WI3gtJkLYqmnFFdXs1oaOA-8TmvnY")
  end
  # [1Hy528GhW6XYnoa6KvcfaKyAn98QF9nYVIdFBL-BRJdw]浅草11月の勤怠
  # [17uvb27n9d-pobk0kVQy-YwJbXhxpEaOt2RBP0vB2j4M]千束11月の勤怠
  # [10s6PURZRWmX1GC8Fg9eUGk208_GQlX49K3wcjjlUYQ0]日暮里11月の勤怠
  # [17u4Ak5YEMLAqW3WI3gtJkLYqmnFFdXs1oaOA-8TmvnY]本部11月の勤怠

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
    sheet[inputline, 3] = "#{inputtime.strftime("%H:%M")} "
  else
    # 退勤時間入力
    sheet[inputline, 4] = "#{inputtime.strftime("%H:%M")} "
  end

  # 勤務場所を入力
  sheet[inputline, 8] = "#{WorkPlace.find($attendance.work_place_id).name}"

  # 交通費の入力があれば入力
  if $attendance.carfare.present?
    sheet[inputline, 10] = "#{$attendance.carfare}"
  end

  # シートの保存
  sheet.save
