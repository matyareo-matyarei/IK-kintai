# 書き込むスプレッドシートを指定
def spreadsheetset
  require 'google_drive'
  require 'active_support/time'
  require 'holiday_japan'
  session = GoogleDrive::Session.from_config('config.json')

  # 毎月の値をセット（勤怠提出されたタイミングで  next→lastへ以降する）
  lastYear = 2021
  lastMonth = 9
  # thisMonthにも↓は貼り付ける
  l_asakusa = '1pAZqkKnK0iP96Uf2RxfH_3Hb6MKHa_QIWGdnW8iL-rk'
  l_senozku = '1YGzLpz1QSDy2vlmHe3bT2QfESiCvvi2Eq6_sVvBBEfw'
  l_nippori = '1P6dS5BsMet_wMQhAewDtNI6Kyp04BMGPfDs774S16ms'
  l_honbu = '1enTR-gWIFltQWJyGF_XJ28lnI6MNjL4uV0yKT_e1vaI'

  nextYear = 2021
  nextMonth = 10
  n_asakusa = '1WvQ-CCvvJr6crK_3kiiqAo37t5AFbmlBgyGGN4c3kNg'
  n_senzoku = '13Yg6gi4y_7UF8dYCvkP5XqnBNInB4gbejgkY8Dytzkc'
  n_nippori = '18WuAXzOVm-geCMsvFKoXrgvUOToOrbAcE2XTlILzjCk'
  n_honbu = '1mftxCkFGVdvyKP7fgdtLfwkxO1OSja6Puz9hFzOZEFs'

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
  l_asakusa = '1pAZqkKnK0iP96Uf2RxfH_3Hb6MKHa_QIWGdnW8iL-rk'
  l_senozku = '1YGzLpz1QSDy2vlmHe3bT2QfESiCvvi2Eq6_sVvBBEfw'
  l_nippori = '1P6dS5BsMet_wMQhAewDtNI6Kyp04BMGPfDs774S16ms'
  l_honbu = '1enTR-gWIFltQWJyGF_XJ28lnI6MNjL4uV0yKT_e1vaI'

  case $user.affiliation_id
    # 前月のスプレッドシート設定
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