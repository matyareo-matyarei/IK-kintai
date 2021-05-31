require "./spreadsheet/set"
unless $attendance.present?
  thisMonth
else
  spreadsheetset
end
# 参照する日報（勤怠提出後、新しい月に書き換えること）
# 浅草5月日報
asakusa = '1sHmravICLzW7yOqpX2aOSZRVP6OG8mUPu0fVJEWc6ng'
# 千束5月日報
senzoku = '1jZgZ_O_qKxPDm_ZLcSAc6NLJsmWowGz-QLA5kQdXHww'
# 日暮里5月日報
nippori = '1WraEIfq_Cy9Qyn16qlgkl_eKOfAszkforVV_iKkYyjw'


# 休憩時間入力
i = 6
eight = Time.parse('8:00') # 8時間の値eight
while i <= 36
  begin
    kousoku = if $user.full_part # 常勤の場合 拘束時間の値=kousoku
                Time.parse(@sheet[i, 11])
              else # 非常勤の場合
                Time.parse(@sheet[i, 12])
              end
    # 出/退勤のセルに値が入っていて、拘束時間が8h以上なら休憩時間1:00を入れる
    @sheet[i, 5] = if @sheet[i, 3].present? && @sheet[i, 4].present? && kousoku.hour >= eight.hour
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
  (6..@sheet.num_rows).each do |row| # セルの行で値が入っているところまで
    syukkin = Time.parse(@sheet[row, 3]) # 出勤時刻
    taikin = Time.parse(@sheet[row, 4]) # 退勤時刻
    start = Time.parse('10:00') # 営業開始時刻
    finish = Time.parse('19:00') #営業終了時刻
    day = Date.parse(@sheet[row, 1]) # 各行の日付
    @sheet[row, 11] = if @sheet[row, 3].present? && @sheet[row, 4].present? # 出勤退勤入力がされていたら
                      if day.sunday? || day.national_holiday? # 日曜／祝日なら
                        if syukkin <= start && taikin >= finish # 営業開始より早く出勤、終了より後に退勤なら1日手当て
                          800
                        else # 途中出退勤の場合、営業時間(10::00~19:00)のうち1hにつき*100
                          if syukkin <= start # 営業開始時刻より前の出勤
                            (taikin - start) / 3600 * 100 # 秒単位で結果が出るので、時給換算
                          elsif taikin >= finish # 営業終了時刻より後の退勤
                            (finish - syukkin) / 3600 * 100
                          else # 出退勤が営業時間内
                            (taikin - syukkin) / 3600 * 100
                          end
                        end
                      elsif day.saturday? # 土曜
                        if syukkin <= start && taikin >= finish # 1日手当ての条件
                          400
                        else # 途中出退勤の場合、営業時間(10::00~19:00)のうち1hにつき*50
                          if syukkin <= start
                            (taikin - Time.parse('10:00')) / 3600 * 50
                          elsif taikin >= finish
                            (finish - syukkin) / 3600 * 50
                          else # 出退勤が営業時間内
                            (taikin - syukkin) / 3600 * 50
                          end
                        end
                      else
                        '' # 土日祝日じゃない
                      end
                    end
  rescue StandardError => e
    puts e.message
    @sheet[row, 11] = '' # 出退勤入ってない
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
    spread = GoogleDrive::Session.from_config('config.json').spreadsheet_by_key(nippou)
    kadou = spread.worksheet_by_title('稼働率')

    # 日報（稼働率シート）の名前から取得するlineを指定
    num = 6
    while num <= 42
      if kadou[num, 1].slice(0, 2) == $user.full_name.slice(0, 2) # 施術者とユーザーがマッチ
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
          @sheet[i + 3, 7] = "0:0#{(treatment_time.to_f * 10).to_i}" # 勤怠の施術時間に反映
          treatment_time_slice = @sheet[i + 3, 7].slice(-3, 3)
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
  # puts treatment_asa, treatment_sen, treatment_nippo
  # 同日に施術時間が入っているシンボルiを定義(Arrayクラス)
  i = treatment_asa.keys & treatment_sen.keys | treatment_asa.keys & treatment_nippo.keys | treatment_sen.keys & treatment_nippo.keys
  if i.present? # 同日施術時間の入力があれば
    i.each do |key| # 同日の施術時間を足したdoujitu_treatment_sumを定義
      doujitu_treatment_sum = treatment_asa[:"#{key}"].to_i + treatment_sen[:"#{key}"].to_i + treatment_nippo[:"#{key}"].to_i
      puts doujitu_treatment_sum
      # シンボルi(key)を一度文字列に変換、数字変換しその値(key)を元にスプレッドシートに反映
      @sheet[key.to_s.to_i + 3, 7] = "0:0#{doujitu_treatment_sum}"
    end
  end
end

@sheet.save
