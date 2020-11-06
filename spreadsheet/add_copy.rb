require "google_drive"

session = GoogleDrive::Session.from_config("config.json")

sheets = session.spreadsheet_by_key("17uvb27n9d-pobk0kVQy-YwJbXhxpEaOt2RBP0vB2j4M")

# 新規スプレッドシートの作成(マイドライブ内に)
# session.create_spreadsheet("スプレッドシート名")

# 既存のスプレッドシートに新規シート(ワークシート)を追加
# sheets.add_worksheet("シート名")

# 作成済みのスプレッドシートをコピーして保存
# sheets.copy("コピー後のシート名")

# 新規作成(コピー)したスプレッドシートのURLやタイトルの取得
# new_sheets = session.create_spreadsheet("新規スプレッドシート名")
# p "https://docs.google.com/spreadsheets/d/#{new_sheets.id}"
# p new_sheets.title