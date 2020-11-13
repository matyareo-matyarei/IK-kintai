require "google_drive"
require 'active_support/all'


session = GoogleDrive::Session.from_config("config.json")

# 書き込むスプレッドシートを指定
case $user.affiliation_id
when 2 # 浅草
  spreads = session.spreadsheet_by_key("1Hy528GhW6XYnoa6KvcfaKyAn98QF9nYVIdFBL-BRJdw")
when 3 # 千束
  spreads = session.spreadsheet_by_key("17uvb27n9d-pobk0kVQy-YwJbXhxpEaOt2RBP0vB2j4M")
when 4 # 日暮里
  spreads = session.spreadsheet_by_key("10s6PURZRWmX1GC8Fg9eUGk208_GQlX49K3wcjjlUYQ0")
when 5 # 本部
  spreads = session.spreadsheet_by_key("17u4Ak5YEMLAqW3WI3gtJkLYqmnFFdXs1oaOA-8TmvnY")
end

# [17uvb27n9d-pobk0kVQy-YwJbXhxpEaOt2RBP0vB2j4M]千束11月の勤怠
# [1Hy528GhW6XYnoa6KvcfaKyAn98QF9nYVIdFBL-BRJdw]浅草11月の勤怠
# [10s6PURZRWmX1GC8Fg9eUGk208_GQlX49K3wcjjlUYQ0]日暮里11月の勤怠
# [17u4Ak5YEMLAqW3WI3gtJkLYqmnFFdXs1oaOA-8TmvnY]本部11月の勤怠


# Userのfull_nameと一致するワークシートを取得
sheet_tittle = $user.full_name
sheet = spreads.worksheet_by_title(sheet_tittle)

# 休憩時間入力
i = 6
ten = Time.parse("10:00") # 10時間の値ten
while i <= 36
  begin
    if $user.full_part #常勤の場合
      kousoku = Time.parse(sheet[i,11]) # 拘束時間の値=kousoku
    else #非常勤の場合
      kousoku = Time.parse(sheet[i,12]) # 拘束時間の値=kousoku
    end
    # 出/退勤のセルに値が入っていて、拘束時間が10時間以上なら休憩時間を入れる
    if sheet[i,3].present? && sheet[i,4].present? && kousoku.hour >= ten.hour
      sheet[i,5] = "1:00"
    else
      sheet[i,5] = ""
    end
  rescue => e
    puts e.message
  end
  i += 1
end
# User登録が非常勤(full_partがfalse)の人は出勤日の内、土と日・祝日に手当てが入る
unless $user.full_part
  (6..sheet.num_rows).each do |row| #セルの行で値が入っているところまで
    begin
      if sheet[row,3].present? && sheet[row,4].present? #出勤退勤入力がされていたら
        if Date.parse(sheet[row,1]).sunday? #日曜なら
          sheet[row,11] = 800
        elsif Date.parse(sheet[row,1]).national_holiday? #祝日なら
          sheet[row,11] = 800
        elsif Date.parse(sheet[row,1]).saturday? #土曜なら
          sheet[row,11] = 400
        else
          sheet[row,11] = "" #土日祝日じゃないなら手当てはなし
        end
      else
        sheet[row,11] = "" #出退勤入ってないと手当てはなし
      end
    rescue => e
      puts e.message
    end
  end
end

# 非常勤の施術者は日報の施術時間を入力
unless $user.full_part
  
end

sheet.save
