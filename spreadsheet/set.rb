# 書き込むスプレッドシートを指定
def spreadsheetset
  require 'google_drive'
  require 'active_support/time'
  require 'holiday_japan'
  session = GoogleDrive::Session.from_config('config.json')
  # 書き込みたいスプレッドシートを指定
  # 2021年1月の場合
  if $attendance.work_days.year == 2021 && $attendance.work_days.month == 1
    case $user.affiliation_id
    when 2 # 浅草
      key = '1KbHBYIM_TPT38HaycXo940MvcNPAOhnNjOEgNvFC2-Q'
    when 3 # 千束
      key = '1yNWXcbcm0-5Jk7RiUcdA7Digsf_yE7tcI3YFtT6Ghmg'
    when 4 # 日暮里
      key = '1RDm8ydUOAxlPfj1r1OgDiHMnC4lepI6ynR-cjpYMdxA'
    when 5 # 本部
      key = '143RsZXyqmeYs2b_IrNUVhQz0lMG1v63GpEkGDbt_DJI'
    end      
  # 2021年2月の場合
elsif $attendance.work_days.year == 2021 && $attendance.work_days.month == 2
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
def thisMonth
  require 'google_drive'
  require 'active_support/time'
  require 'holiday_japan'
  session = GoogleDrive::Session.from_config('config.json')
  case $user.affiliation_id
    # 2021年1月の場合
  when 2 # 浅草
    key = '1KbHBYIM_TPT38HaycXo940MvcNPAOhnNjOEgNvFC2-Q'
  when 3 # 千束
    key = '1yNWXcbcm0-5Jk7RiUcdA7Digsf_yE7tcI3YFtT6Ghmg'
  when 4 # 日暮里
    key = '1RDm8ydUOAxlPfj1r1OgDiHMnC4lepI6ynR-cjpYMdxA'
  when 5 # 本部
    key = '143RsZXyqmeYs2b_IrNUVhQz0lMG1v63GpEkGDbt_DJI'
  end      
  @sheet = session.spreadsheet_by_key(key).worksheet_by_title("#{$user.full_name}")
end