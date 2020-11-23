require 'google_drive'
require 'active_support/time'
require 'holiday_japan'

session = GoogleDrive::Session.from_config('config.json')
key = '17uvb27n9d-pobk0kVQy-YwJbXhxpEaOt2RBP0vB2j4M'
sheet = session.spreadsheet_by_key(key).worksheet_by_title('水野雅之')

# 手当て処理
(6..36).each do |row| # セルの行で値が入っているところまで
  syukkin = Time.parse(sheet[row, 3]) # 出勤時間
  taikin = Time.parse(sheet[row, 4]) # 退勤時間
  start = Time.parse('10:00') # 営業開始時間
  finish = Time.parse('19:00') #営業終了時間
  day = Date.parse(sheet[row, 1]) # 各行の日付
  sheet[row, 11] = if sheet[row, 3].present? && sheet[row, 4].present? # 出勤退勤入力あり
                    if day.sunday? || day.national_holiday? # 日曜／祝日なら
                      if syukkin <= start && taikin >= finish#10時前出勤かつ19時後退勤なら1日手当て
                        800
                      else # 途中出退勤の場合、営業時間(10::00~19:00)のうち1hにつき*100
                        if syukkin <= start # 営業時間前出勤
                          (taikin - start) / 3600 * 100
                        elsif taikin >= finish # 営業時間後退勤
                          (finish - syukkin) / 3600 * 100
                        else # 出退勤が営業時間内
                          (taikin - syukkin) / 3600 * 100
                        end
                      end
                    elsif day.saturday? # 土曜
                      if syukkin <= start && taikin >= finish
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
  sheet[row, 11] = '' # 出退勤入ってない
end


sheet.save

# puts Time.parse(sheet[6,1])
# C3セルの情報を取得
# シート側で数値が書き込まれていても文字列が返ってくるので要注意

# C3セルの値や数式を取得
# 配列形式で取得すると「シートに表示されている文字(数値)」が返ってくるが、
# input_valueでは「数式や値そのもの」が返ってくる
# p sheets.input_value("C2")

# 配列形式やinput_valueではシートの値を文字列として取得できるが、
# numeric_valueでは数値として取得することが可能??（数字のみ表示○、計算結果などは×）
# p sheets.numeric_value("C2")
