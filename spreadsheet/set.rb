# 書き込むスプレッドシートを指定
def spreadsheetset
  require 'google_drive'
  require 'active_support/time'
  require 'holiday_japan'
  session = GoogleDrive::Session.from_config('config.json')
  # 書き込みたいスプレッドシートを指定
  # 2021年2月の場合
  if $attendance.work_days.year == 2021 && $attendance.work_days.month == 2
    case $user.affiliation_id
    when 2 # 浅草
      key = '1jltuIubX_J-C6yogaSco39YlEheGHdyf5BMWdm2VxhI'
    when 3 # 千束
      key = '1uvihPlaCcfePnR0vUS01EiUE5-7fOPA5NCiOJXAJfpw'
    when 4 # 日暮里
      key = '1gZKykJpy1i4-OcswdpEA8aWRJiEAeS7fAUwXoaxaiDI'
    when 5 # 本部
      key = '11a2dWRK2xGZqfz_fF_1GDQRgKHxl8zYBob8iaytFlQs'
    end
  # 2021年3月の場合
elsif $attendance.work_days.year == 2021 && $attendance.work_days.month == 3
    case $user.affiliation_id
    when 2 # 浅草
      key = '1K7qx0lzQQNIaQvdjP23tpxL-gqCai1ALNWpjmUYMQa0'
    when 3 # 千束
      key = '1JXy9oaZ2wzjDJGiYiux4up24KPH-AaWnmj6JM8OQiOM'
    when 4 # 日暮里
      key = '1ZHgTLkO_ZKu1rzvw8EyTxvMtYjbqihxPAr_pRO_nbLo'
    when 5 # 本部
      key = '1H7BDBtesoOoDupZfjXMs2Ial25qwOL3NYq2xAp4HVTY'
    end
  else
  end
  # $user.full_nameと一致するワークシートを指定＝@sheet
  @sheet = session.spreadsheet_by_key(key).worksheet_by_title("#{$user.full_name}")
end

# 出退勤入力なしに月末処理を行った場合の処理
def thisMonth
  require 'google_drive'
  require 'active_support/time'
  require 'holiday_japan'
  session = GoogleDrive::Session.from_config('config.json')
  case $user.affiliation_id
    # 2021年2月設定
  when 2 # 浅草
    key = '1jltuIubX_J-C6yogaSco39YlEheGHdyf5BMWdm2VxhI'
  when 3 # 千束
    key = '1uvihPlaCcfePnR0vUS01EiUE5-7fOPA5NCiOJXAJfpw'
  when 4 # 日暮里
    key = '1gZKykJpy1i4-OcswdpEA8aWRJiEAeS7fAUwXoaxaiDI'
  when 5 # 本部
    key = '11a2dWRK2xGZqfz_fF_1GDQRgKHxl8zYBob8iaytFlQs'
  end      
  @sheet = session.spreadsheet_by_key(key).worksheet_by_title("#{$user.full_name}")
end