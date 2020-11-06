require "google_drive"

session = GoogleDrive::Session.from_config("config.json")

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