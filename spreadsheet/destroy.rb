require "./spreadsheet/set"
spreadsheetset

begin  
  # 出退勤記録の削除コマンド
  # ***入力されている日付を基準にスプレットシートの入力する箇所を定める***[inputline]
  inputline = $attendance.work_days.day + 5
  
  # 出勤(true)の場合／退勤(false)の場合を分岐
  if $attendance.in_out
    @sheet[inputline, 3] = ""    # 出勤時間を削除
  else
    @sheet[inputline, 4] = ""    # 退勤時間を削除
  end
  @sheet[inputline, 8] = ""      # 勤務場所を削除
  @sheet[inputline, 10] = ""     # 交通費の入力の削除

  if $user.full_part
    @sheet[inputline, 17] = ""   # 備考欄の削除（常勤）
  else
  @sheet[inputline, 16] = ""     # 備考欄の削除（非常勤）
  end

  @sheet.save

# 範囲外の日付指定の場合
rescue StandardError => e
  puts e.message
  puts "正しくスプレッドシートには反映されていません"
end
