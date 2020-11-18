require 'google_drive'
require 'active_support/time'
session = GoogleDrive::Session.from_config('config.json')

# 書き込みたいスプレッドシートを、千束の勤怠に指定する
spreads = session.spreadsheet_by_key('17uvb27n9d-pobk0kVQy-YwJbXhxpEaOt2RBP0vB2j4M')

# "水野雅之"Userのfull_nameと一致するワークシートを取得
worksheet_tittle = '水野雅之'
sheet = spreads.worksheet_by_title(worksheet_tittle)

# 浅草11月日報
asakusa = '1jjNHb3LP8QhaoiqdS-MHtP8KAfvGbMiKhs7bKTnagdo'
# 千束11月日報
senzoku = '1DXCwkxgS0OOPGvU8FtSSBH1EJ9nfLTjod3QJ_mmbYfw'
# 日暮里11月日報
nippori = '1xVl_kN5ca5ptSkHzTCFD4m1ffKAwVJ2u0EL3hv_Vs4M'

nippou = [asakusa, senzoku, nippori]
nippou.each do |nippou|
  # 各院の日報スプレッドシートを指定
  spread = session.spreadsheet_by_key(nippou)
  kadou = spread.worksheet_by_title('稼働率')

  # 日報（稼働率シート）の名前から取得するlineを指定
  num = 6
  while num <= 42
    if kadou[num, 1].slice(0, 2) == '水野' # ここは[sheet_tittle.slice(0,2)]施術者とユーザーがマッチしたら
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

sheet.save
