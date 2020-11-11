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

# Google Drive上にディレクトリを作成する
## ディレクトリを作成する場所をGoogle DriveのURLで指定する
drive_dir = session.collection_by_url("https://drive.google.com/drive/folders/1fTYhF5lR0l05GXWuQsMqsJ1YkvqdCmMn")

## 上記で指定したディレクトリ内に新たにディレクトリを作成する
drive_dir.create_subcollection("ディレクトリ名")

# スプレッドシートをコピーして指定したディレクトリに保存(移動)
## コピー元のスプレッドシートを取得
sheets = session.spreadsheet_by_key("1F_3hgDzgPb0Eh9VD6aPPeVLn8a3OAonEH2kBFFp9h0Q")

## シートのコピー 
copy_sheet = sheets.copy("コピー後のシート名_001")

## 保存したいディレクトリのURLを指定
drive_dir = session.collection_by_url("https://drive.google.com/drive/folders/1Umuix7Wp_wlKSBXRq_xErsKMErS2YB3k")

## コピーしたシートを先程指定したディレクトリ内に保存
drive_dir.add(copy_sheet)