require "./spreadsheet/set"
spreadsheetset

begin
  ## スプレッドシートへの書き込み
  # ***入力されている日付を基準にスプレットシートの入力する箇所を定める***[inputline]
  inputline = $attendance.work_days.day + 5
  inputtime = $attendance.work_time
  
  # 出勤(true)の場合／退勤(false)の場合を分岐
  if $attendance.in_out
    # 出勤時間入力
    @sheet[inputline, 3] = "#{inputtime.strftime('%H:%M')} "
  else
    # 退勤時間入力
    @sheet[inputline, 4] = "#{inputtime.strftime('%H:%M')} "
  end
  
  # 勤務場所を入力
  @sheet[inputline, 8] = WorkPlace.find($attendance.work_place_id).name.to_s
  
  # 交通費入力（あれば）
  @sheet[inputline, 10] = $attendance.carfare.to_s if $attendance.carfare.present?
  
  # 備考欄入力（あれば）
  if $user.full_part #常勤なら
    @sheet[inputline, 17] = $attendance.remarks.to_s if $attendance.remarks.present?
  else #非常勤なら
    @sheet[inputline, 16] = $attendance.remarks.to_s if $attendance.remarks.present?
  end
  
  # シートの保存
  @sheet.save

# 範囲外の日付指定の場合
rescue StandardError => e
  puts e.message
  puts "正しくスプレッドシートには反映されていません"
end