  require "google_drive"

  session = GoogleDrive::Session.from_config("config.json")
  # 書き込みたいスプレッドシートを、千束の勤怠に指定する
  spreads = session.spreadsheet_by_key("17uvb27n9d-pobk0kVQy-YwJbXhxpEaOt2RBP0vB2j4M")
  # Userのfull_nameと一致するワークシートを取得
  worksheet_tittle = $user.full_name
  worksheet = spreads.worksheet_by_title(worksheet_tittle)

  ## スプレッドシートへの書き込み
  # ***入力されている日付を基準にスプレットシートの入力する箇所を定める***[inputline]
  inputline = $attendance.work_days.day + 5
  inputtime = $attendance.work_time

  # 出勤(true)の場合／退勤(false)の場合を分岐
  if $attendance.in_out
    # 出勤時間入力
    worksheet[inputline, 3] = "#{inputtime.strftime("%H:%M")} "
  else
    # 退勤時間入力
    worksheet[inputline, 4] = "#{inputtime.strftime("%H:%M")} "
  end

  # 勤務場所を入力
  worksheet[inputline, 8] = "#{WorkPlace.find($attendance.work_place_id).name}"

  # 交通費の入力があれば入力
  if $attendance.carfare.present?
    worksheet[inputline, 10] = "#{$attendance.carfare}"
  end

  # シートの保存
  worksheet.save



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
