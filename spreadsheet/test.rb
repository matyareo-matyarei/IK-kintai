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
    if kadou[num, 1].slice(0, 2) == '水野' # ここは[sheet_tittle.slice(0,2)]施術者とユーザーがマッチしたら
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
        sheet[i + 3, 7] = "0:0#{(treatment_time.to_f * 10).to_i}" # 勤怠の施術時間に反映(小数点表示)
        treatment_time_slice = sheet[i + 3, 7].slice(-3,3)
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
puts treatment_asa,treatment_sen,treatment_nippo
#同日に施術時間が入っているシンボルiを定義(Arrayクラス)
i = treatment_asa.keys & treatment_sen.keys | treatment_asa.keys & treatment_nippo.keys | treatment_sen.keys & treatment_nippo.keys
if i.present? #同日施術時間の入力があれば
  i.each do |key| #同日の施術時間を足したdoujitu_treatment_sumを定義
    doujitu_treatment_sum = treatment_asa[:"#{key}"].to_i + treatment_sen[:"#{key}"].to_i + treatment_nippo[:"#{key}"].to_i
    puts doujitu_treatment_sum
    #シンボルi(key)を一度文字列に変換、数字変換しその値(key)を元にスプレッドシートに反映
    sheet[key.to_s.to_i + 3, 7] = "0:0#{doujitu_treatment_sum}"
  end
end


sheet.save
