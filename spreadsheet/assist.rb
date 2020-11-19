require 'google_drive'
require 'active_support/all'

session = GoogleDrive::Session.from_config('config.json')

# //セット//
# 書き込む勤怠シートを指定
case $user.affiliation_id
when 2 # 浅草
  spreads = session.spreadsheet_by_key('1c7my0A20BFbcG9hC62MQr1TkwEYj2wjLPeSa7BUio2Q')
when 3 # 千束
  spreads = session.spreadsheet_by_key('1DgfB3Ayrk0QA7VUqeTO3P0aoL1pwgZKCPsnWmtHjLH8')
when 4 # 日暮里
  spreads = session.spreadsheet_by_key('1_cLUUjCG-M16FvS9I_s9m7L6khCr4IjWNWmRc75zFZg')
when 5 # 本部
  spreads = session.spreadsheet_by_key('1gKlozDb0P8VSYQw2wsR11JPgCtgVvvr-sbHvl45ShhI')
end

# [1DgfB3Ayrk0QA7VUqeTO3P0aoL1pwgZKCPsnWmtHjLH8]千束11月の勤怠
# [1c7my0A20BFbcG9hC62MQr1TkwEYj2wjLPeSa7BUio2Q]浅草11月の勤怠
# [1_cLUUjCG-M16FvS9I_s9m7L6khCr4IjWNWmRc75zFZg]日暮里11月の勤怠
# [1gKlozDb0P8VSYQw2wsR11JPgCtgVvvr-sbHvl45ShhI]本部11月の勤怠

# 浅草11月日報
asakusa = '1jjNHb3LP8QhaoiqdS-MHtP8KAfvGbMiKhs7bKTnagdo'
# 千束11月日報
senzoku = '1DXCwkxgS0OOPGvU8FtSSBH1EJ9nfLTjod3QJ_mmbYfw'
# 日暮里11月日報
nippori = '1xVl_kN5ca5ptSkHzTCFD4m1ffKAwVJ2u0EL3hv_Vs4M'

# //セット//

# Userのfull_nameと一致するワークシートを取得
sheet_tittle = $user.full_name
sheet = spreads.worksheet_by_title(sheet_tittle)

# 休憩時間入力
i = 6
eight = Time.parse('8:00') # 8時間の値eight
while i <= 36
  begin
    kousoku = if $user.full_part # 常勤の場合 拘束時間の値=kousoku
                Time.parse(sheet[i, 11])
              else # 非常勤の場合
                Time.parse(sheet[i, 12])
              end
    # 出/退勤のセルに値が入っていて、拘束時間が8h以上なら休憩時間1:00を入れる
    sheet[i, 5] = if sheet[i, 3].present? && sheet[i, 4].present? && kousoku.hour >= eight.hour
                    '1:00'
                  else
                    ''
                  end
  rescue StandardError => e
    puts e.message
  end
  i += 1
end
# 手当て入力
# User登録が非常勤(full_partがfalse)の人は出勤日の内、土と日・祝日に手当てが入る
unless $user.full_part
  (6..sheet.num_rows).each do |row| # セルの行で値が入っているところまで
    kousoku = Time.parse(sheet[row, 12]) # 拘束時間の値=kousoku
    day = Date.parse(sheet[row, 1]) # 各行の日付
    sheet[row, 11] = if sheet[row, 3].present? && sheet[row, 4].present? # 出退勤入力がされていたら
                      if day.sunday? || day.national_holiday? # 日・祝日なら
                        if kousoku.hour >= eight.hour # 8h以上なら１日手当て、それ以下は半日手当て
                          800
                        else
                          400
                        end
                      elsif day.saturday? # 土曜なら
                        if kousoku.hour >= eight.hour
                          400
                        else
                          200
                        end
                      else
                        '' # 土日祝日じゃなければ手当てなし
                      end
                    else
                      '' # 出退勤入ってなければ手当てなし
                    end
  rescue StandardError => e
    puts e.message
  end
end

# 非常勤の施術者は日報の施術時間を入力
unless $user.full_part
  nippou = [asakusa, senzoku, nippori]
  nippou.each do |nippou|
    # 各院の日報スプレッドシートを指定
    spread = session.spreadsheet_by_key(nippou)
    kadou = spread.worksheet_by_title('稼働率')

    # 日報（稼働率シート）の名前から取得するlineを指定
    num = 6
    while num <= 42
      if kadou[num, 1].slice(0, 2) == sheet_tittle.slice(0, 2) # 施術者とユーザーがマッチ
        # 入力したユーザー名(頭２つ)とマッチする日報の施術時間のライン＝n を定義
        n = num + 1
      end
      num += 4
    end

    # 施術時間入力
    i = 3
    while i <= 33
      begin
        treatment_time = kadou[n, i] # 日報で名前が一致した施術時間ラインnと1〜31日まで
        if treatment_time.present? # 施術時間が入っていれば
          sheet[i + 3, 7] = "0:#{(treatment_time.to_f * 10).to_i}" # 勤怠の施術時間に反映
        end
      rescue StandardError => e
        puts e.message
      end
      i += 1
    end
  end
end

sheet.save
