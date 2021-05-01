# 書き込むスプレッドシートを指定
def spreadsheetset
  require 'google_drive'
  require 'active_support/time'
  require 'holiday_japan'
  session = GoogleDrive::Session.from_config('config.json')
  # 書き込みたいスプレッドシートを指定

  # 2021年4月の場合
if $attendance.work_days.year == 2021 && $attendance.work_days.month == 4
    case $user.affiliation_id
    when 2 # 浅草
      key = '1c3cmqFMBkmL1XEH6Vrj7ICaFC-jQfQwvRn99e1bYcYs'
    when 3 # 千束
      key = '1oXC_FZMMSujDiVJswCEZaTsQyJERmD6gImGwjcj3nQw'
    when 4 # 日暮里
      key = '1ROu8pqYZ1XfXrPKoqm_USlnhhDkS9nJ0-KuLWqalW14'
    when 5 # 本部
      key = '1t2P08n13clMPWgyrPAukFWw3UVZ2vfkcohCoNThFD7c'
    end

  # 2021年5月の場合
elsif $attendance.work_days.year == 2021 && $attendance.work_days.month == 5
  case $user.affiliation_id
  when 2 # 浅草
    key = '1EPaGc_yEBxEWZ_6LEGsb3PhopF1hkImzuKl2mf5Sofw'
  when 3 # 千束
    key = '1QQvo7UATOEqDDLyHxDJRm8-TyoPnFJ7gMU9ZxbwGOP4'
  when 4 # 日暮里
    key = '13Eg0WyNC8sHBLqSc6U-D1244ACTGKxKb5Q9cwEHk7W4'
  when 5 # 本部
    key = '1tSdYwz8UDWFCIzaHGBuXsDLgbCZE_zTAlylURKs4t7Y'
  end

  # 2021年6月の場合
elsif $attendance.work_days.year == 2021 && $attendance.work_days.month == 6
  case $user.affiliation_id
  when 2 # 浅草
    key = ''
  when 3 # 千束
    key = ''
  when 4 # 日暮里
    key = ''
  when 5 # 本部
    key = ''
  end

  else
  end
  # $user.full_nameと一致するワークシートを指定＝@sheet
  @sheet = session.spreadsheet_by_key(key).worksheet_by_title("#{$user.full_name}")
end

# 出退勤入力なしに月末処理を行った場合の処理
# 一度でも出退勤を記録していれば、$attendanceに入力した月のデータが入る
def thisMonth
  require 'google_drive'
  require 'active_support/time'
  require 'holiday_japan'
  session = GoogleDrive::Session.from_config('config.json')
  case $user.affiliation_id
    # 2021年4月のスプレッドシート設定
  when 2 # 浅草
    key = '1c3cmqFMBkmL1XEH6Vrj7ICaFC-jQfQwvRn99e1bYcYs'
  when 3 # 千束
    key = '1oXC_FZMMSujDiVJswCEZaTsQyJERmD6gImGwjcj3nQw'
  when 4 # 日暮里
    key = '1ROu8pqYZ1XfXrPKoqm_USlnhhDkS9nJ0-KuLWqalW14'
  when 5 # 本部
    key = '1t2P08n13clMPWgyrPAukFWw3UVZ2vfkcohCoNThFD7c'
  end      
  @sheet = session.spreadsheet_by_key(key).worksheet_by_title("#{$user.full_name}")
end