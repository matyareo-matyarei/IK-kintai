require 'line_notify'

# 水野LINEにメッセージを送る
line_notify = LineNotify.new('xRIoOhQYmqqQIzlKM1AzyY6Y1ThZaWBSFpyp0BSi58O')
# 千束グループLINE
# line_notify = LineNotify.new('fiMG3651hSOdRThp1TJbSNk23KY8A1EqHeoWt6lpJVa')
# 浅草グループLINE
# line_notify = LineNotify.new('ztzPsLKJaSKKjBZKrCCy0KDWsMovm4Av7nGEgonO0fm')

options = {message: '入力完了しました'}
line_notify.ping(options)