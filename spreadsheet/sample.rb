require 'google_drive'
require 'active_support/time'
require 'holiday_japan'

session = GoogleDrive::Session.from_config('config.json')
key = '17uvb27n9d-pobk0kVQy-YwJbXhxpEaOt2RBP0vB2j4M'
sheet = session.spreadsheet_by_key(key).worksheet_by_title('水野雅之')

eight = Time.parse('8:00') # 8時間の値eight
# 手当て入力
(6..sheet.num_rows).each do |row| # セルの行で値が入っているところまで
  kousoku = Time.parse(sheet[row, 12]) # 拘束時間の値=kousoku
  day = Date.parse(sheet[row, 1]) # 各行の日付
  sheet[row, 11] = if sheet[row, 3].present? && sheet[row, 4].present? # 出勤退勤入力がされていたら
                    if day.sunday? || day.national_holiday? # 日曜又は祝日なら
                      if kousoku.hour >= eight.hour # 8h以上なら１日手当て
                        800
                      else # 8h未満の場合、営業時間(10::00~19:00)のうち1hにつき*100
                        if Time.parse(sheet[row, 3]) <= Time.parse('10:00') # 10時前出勤
                          (Time.parse(sheet[row, 4]) - Time.parse('10:00')) / 3600 * 100
                        elsif Time.parse(sheet[row, 4]) >= Time.parse('19:00') # 19時後退勤
                          (Time.parse('19:00') - Time.parse(sheet[row, 3])) / 3600 * 100
                        else # 出退勤が営業時間内
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
                          puts Time.parse(sheet[row, 3])
                          (Time.parse('19:00') - Time.parse(sheet[row, 3])) / 3600 * 50
                        else # 出退勤が営業時間内
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
