# 書き込むスプレッドシートを指定
def spreadsheetset
  require 'google_drive'
  require 'active_support/time'
  require 'holiday_japan'
  session = GoogleDrive::Session.from_config('config.json')

  # 毎月の値をセット（勤怠提出されたタイミングで  next→lastへ以降する）
  lastYear = 2021
  lastMonth = 5
  # thisMonthにも↓は貼り付ける
  l_asakusa = '1EPaGc_yEBxEWZ_6LEGsb3PhopF1hkImzuKl2mf5Sofw'
  l_senozku = '1QQvo7UATOEqDDLyHxDJRm8-TyoPnFJ7gMU9ZxbwGOP4'
  l_nippori = '13Eg0WyNC8sHBLqSc6U-D1244ACTGKxKb5Q9cwEHk7W4'
  l_honbu = '1tSdYwz8UDWFCIzaHGBuXsDLgbCZE_zTAlylURKs4t7Y'

  nextYear = 2021
  nextMonth = 6
  n_asakusa = '1L9o9G-Y9s3LEeaaN5gR9sT2tzQEkLL_EbQIRQlLsL9Q'
  n_senzoku = '1yvpbKjVmp2d2CwV3AJWeEES7JjGfE20OThM_rRLnbio'
  n_nippori = '12nLzwilBlsURdsQ8G1wmW9QvWSvKhVGRSI4RbSEEFdM'
  n_honbu = '1gzHoGl2zzfJkDrgNfZNHIRtqQNKFa0YZcY46HrjpTUQ'

  # 書き込みたいスプレッドシートを指定
  key = MonthSet( lastYear, lastMonth, l_asakusa, l_senozku, l_nippori, l_honbu,  nextYear, nextMonth, n_asakusa, n_senzoku, n_nippori, n_honbu)

  # $user.full_nameと一致するワークシートを指定＝@sheet
  @sheet = session.spreadsheet_by_key(key).worksheet_by_title("#{$user.full_name}")

end

# 出退勤入力なしに月末処理を行った場合の処理
# ※一度でも出退勤を記録していれば、$attendanceに入力した月のデータが入る
def thisMonth
  require 'google_drive'
  require 'active_support/time'
  require 'holiday_japan'
  session = GoogleDrive::Session.from_config('config.json')

  # 上の前月データ(l_asakusa~l_honbu)をコピーして↓に貼り付ける
  l_asakusa = '1EPaGc_yEBxEWZ_6LEGsb3PhopF1hkImzuKl2mf5Sofw'
  l_senozku = '1QQvo7UATOEqDDLyHxDJRm8-TyoPnFJ7gMU9ZxbwGOP4'
  l_nippori = '13Eg0WyNC8sHBLqSc6U-D1244ACTGKxKb5Q9cwEHk7W4'
  l_honbu = '1tSdYwz8UDWFCIzaHGBuXsDLgbCZE_zTAlylURKs4t7Y'

  case $user.affiliation_id
    # 2021年4月のスプレッドシート設定
  when 2 # 浅草
    key = l_asakusa
  when 3 # 千束
    key = l_senozku
  when 4 # 日暮里
    key = l_nippori
  when 5 # 本部
    key = l_honbu
  end      
  @sheet = session.spreadsheet_by_key(key).worksheet_by_title("#{$user.full_name}")
end


def MonthSet( lastYear, lastMonth, l_asakusa, l_senozku, l_nippori, l_honbu,  nextYear, nextMonth, n_asakusa, n_senzoku, n_nippori, n_honbu)
  # 前月のスプレッドシートSet
  if $attendance.work_days.year == lastYear && $attendance.work_days.month == lastMonth
    case $user.affiliation_id
    when 2 # 浅草
      key = l_asakusa
    when 3 # 千束
      key = l_senozku
    when 4 # 日暮里
      key = l_nippori
    when 5 # 本部
      key = l_honbu
    end

  # 翌月のスプレッドシートSet
  elsif $attendance.work_days.year == nextYear && $attendance.work_days.month == nextMonth
    case $user.affiliation_id
    when 2 # 浅草
      key = n_asakusa
    when 3 # 千束
      key = n_senzoku
    when 4 # 日暮里
      key = n_nippori
    when 5 # 本部
      key = n_honbu
    end
  else
  end
  return key
end