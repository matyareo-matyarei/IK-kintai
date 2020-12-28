require 'line_notify'

case $user.affiliation_id
when 2 # 浅草
  line_notify = LineNotify.new('ztzPsLKJaSKKjBZKrCCy0KDWsMovm4Av7nGEgonO0fm')
when 3 # 千束
  line_notify = LineNotify.new('fiMG3651hSOdRThp1TJbSNk23KY8A1EqHeoWt6lpJVa')
when 4 # 日暮里

when 5 # 本部

end

# 水野LINEにメッセージを送る
# line_notify = LineNotify.new('xRIoOhQYmqqQIzlKM1AzyY6Y1ThZaWBSFpyp0BSi58O')

options = {message: "#{$user.full_name}さんが入力完了しました"}
line_notify.ping(options)