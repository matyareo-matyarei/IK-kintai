# 書き込むスプレッドシートを指定
def spreadsheetset
  require 'google_drive'
  require 'active_support/time'
  require 'holiday_japan'
  session = GoogleDrive::Session.from_config('config.json')

  # 毎月の値をセット（勤怠提出されたタイミングで  next→lastへ以降する）
  lastYear = 2021
  lastMonth = 12
  # thisMonthにも↓は貼り付ける
  l_asakusa = '1tdsXWcAf6EmmtQAckeq1bfjg1FUnhyniHHzcgoI74zU'
  l_senozku = '1JMzcpA6aX2Q9kbMHKxk_-PS0s5alROnuEH6I6d6S7kM'
  l_nippori = '1pBXRhoZODA0dwEn0lYknETOsj-nLKQfpMREo4zDvmts'
  l_honbu = '1LJVIuLpwm7WVKUGBNFo_wh4-KTlS2hISGnGCk8N6jA8'

  nextYear = 2022
  nextMonth = 1
  n_asakusa = '1gzfGxILAwvqNfmfldH1Z_CGvKcRPhczwEK6p4UaHBc4'
  n_senzoku = '1c9h4qxRf6-61htUin-180cjGQOJS6RSSBnFML52mZmE'
  n_nippori = '1bKmuxbh4ybGGiFkCq0Cqq0Gy4q91xMCMZEJb-vQhWOc'
  n_honbu = '17ISGfbCS7LBpSqjJ9hmw-UQta-sjum5ITUw-E3akWxk'

  
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
  l_asakusa = '1tdsXWcAf6EmmtQAckeq1bfjg1FUnhyniHHzcgoI74zU'
  l_senozku = '1JMzcpA6aX2Q9kbMHKxk_-PS0s5alROnuEH6I6d6S7kM'
  l_nippori = '1pBXRhoZODA0dwEn0lYknETOsj-nLKQfpMREo4zDvmts'
  l_honbu = '1LJVIuLpwm7WVKUGBNFo_wh4-KTlS2hISGnGCk8N6jA8'

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