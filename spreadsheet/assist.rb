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
    sheet[row, 11] = if sheet[row, 3].present? && sheet[row, 4].present? #出退勤入力あれば
                      if day.sunday? || day.national_holiday? # 日曜又は祝日なら
                        if kousoku.hour >= eight.hour # 8h以上なら１日手当て
                          800
                        else # 8h未満の場合、営業時間(10::00~19:00)のうち1hにつき*100
                          if Time.parse(sheet[row, 3]) <= Time.parse('10:00') # 10時前出勤
                            (Time.parse(sheet[row, 4]) - Time.parse('10:00')) / 3600 * 100
                          elsif Time.parse(sheet[row, 4]) >= Time.parse('19:00') # 19時後退勤
                            (Time.parse('19:00') - Time.parse(sheet[row, 3])) / 3600 * 100
                          else # 出退勤が10::00~19:00内
                            (Time.parse(sheet[row, 4]) - Time.parse(sheet[row, 3])) / 3600 * 100
                          end
                        end
                      elsif day.saturday? # 土曜
                        if kousoku.hour >= eight.hour
                          400
                        else # 8h未満の場合、営業時間(10::00~19:00)のうち1hにつき*50
                          if Time.parse(sheet[row, 3]) <= Time.parse('10:00') # 10時前出勤
                            (Time.parse(sheet[row, 4]) - Time.parse('10:00')) / 3600 * 50
                          elsif Time.parse(sheet[row, 4]) >= Time.parse('19:00') # 19時後退勤
                            (Time.parse('19:00') - Time.parse(sheet[row, 3])) / 3600 * 50
                          else # 出退勤が10::00~19:00内
                            (Time.parse(sheet[row, 4]) - Time.parse(sheet[row, 3])) / 3600 * 50
                          end
                        end
                      else
                        '' # 土日祝日じゃない
                      end
                    else
                      '' # 出退勤入ってない
                    end
rescue StandardError => e
    puts e.message
  end
end

# 非常勤の施術者は日報の施術時間を入力
unless $user.full_part
  nippou = [asakusa, senzoku, nippori]
  treatment_asa = {}
  treatment_sen = {}
  treatment_nippo = {}
  nippou.each do |nippou|
    # 各院の日報スプレッドシートを指定
    spread = session.spreadsheet_by_key(nippou)
    kadou = spread.worksheet_by_title('稼働率')

    # 日報（稼働率シート）の名前から取得するlineを指定
    num = 6
    while num <= 42
      if kadou[num, 1].slice(0, 2) == sheet_tittle.slice(0, 2) # 施術者とユーザーがマッチ
        # 入力したユーザー名(頭２つ)とマッチする日報の施術時間のライン＝namematch_line を定義
        namematch_line = num + 1
      end
      num += 4
    end

    # 施術時間入力
    i = 3
    while i <= 33
      begin
        treatment_time = kadou[namematch_line, i] # namematch_lineと1〜31日まで
        if treatment_time.present? # 施術時間が入っていれば
          sheet[i + 3, 7] = "0:0#{(treatment_time.to_f * 10).to_i}" # 勤怠の施術時間に反映
          treatment_time_slice = sheet[i + 3, 7].slice(-3, 3)
          case nippou
          when asakusa
            treatment_asa[:"#{i}"] = treatment_time_slice
          when senzoku
            treatment_sen[:"#{i}"] = treatment_time_slice
          when nippori
            treatment_nippo[:"#{i}"] = treatment_time_slice
          end
        end
      rescue StandardError => e
        puts e.message
      end
      i += 1
    end
  end
  # 同日に施術時間が入っていたら合計値を入れる処理
  puts treatment_asa, treatment_sen, treatment_nippo
  # 同日に施術時間が入っているシンボルiを定義(Arrayクラス)
  i = treatment_asa.keys & treatment_sen.keys | treatment_asa.keys & treatment_nippo.keys | treatment_sen.keys & treatment_nippo.keys
  if i.present? # 同日施術時間の入力があれば
    i.each do |key| # 同日の施術時間を足したdoujitu_treatment_sumを定義
      doujitu_treatment_sum = treatment_asa[:"#{key}"].to_i + treatment_sen[:"#{key}"].to_i + treatment_nippo[:"#{key}"].to_i
      puts doujitu_treatment_sum
      # シンボルi(key)を一度文字列に変換、数字変換しその値(key)を元にスプレッドシートに反映
      sheet[key.to_s.to_i + 3, 7] = "0:0#{doujitu_treatment_sum}"
    end
  end
end

sheet.save
