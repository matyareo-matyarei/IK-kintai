def spreadsheetset
  require 'google_drive'
  require 'active_support/time'
  require 'holiday_japan'
  session = GoogleDrive::Session.from_config('config.json')
  # 書き込みたいスプレッドシートを指定
  # 勤怠入力の日付が2020年11月の場合
  if $attendance.work_days.year == 2020 && $attendance.work_days.month == 11
    # 書き込むスプレッドシートを、[$user.affiliation_id]登録所属院で指定
    # （浅草:2、 千束:3、 日暮里:4、 本部:5）
    case $user.affiliation_id
    when 2 # 浅草
      key = '1c7my0A20BFbcG9hC62MQr1TkwEYj2wjLPeSa7BUio2Q'
    when 3 # 千束
      key = '1DgfB3Ayrk0QA7VUqeTO3P0aoL1pwgZKCPsnWmtHjLH8'
    when 4 # 日暮里
      key = '1_cLUUjCG-M16FvS9I_s9m7L6khCr4IjWNWmRc75zFZg'
    when 5 # 本部
      key = '1gKlozDb0P8VSYQw2wsR11JPgCtgVvvr-sbHvl45ShhI'
  end

  # 2020年12月の場合
  elsif $attendance.work_days.year == 2020 && $attendance.work_days.month == 12
    case $user.affiliation_id
    when 2 # 浅草
      key = '1CNB8327QstH7n0wX9xLUO3cFWbZvZpbzLobCzf-UP04'
    when 3 # 千束
      key = '1cMErIo_mOrupNc7-CsWuXx60M5xyaa2Yu11HgYvxgps'
    when 4 # 日暮里
      key = '1OA2ZT6X29aafkF5cEhdPa5r76PS0slNYgd1qAI4A218'
    when 5 # 本部
      key = '1ZBWtL9tOGrm1MEmAuuxiWpGi_JAzQJw640MFEpa4lvU'
    end
  else
  end

  # $user.full_nameと一致するワークシートを指定＝@sheet
  @sheet = session.spreadsheet_by_key(key).worksheet_by_title("#{$user.full_name}")

end  
