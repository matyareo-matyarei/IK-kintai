# アプリケーション名
## IKーkintai  <img src="https://user-images.githubusercontent.com/71745650/98325424-1eac6400-2032-11eb-899c-735967326da2.jpg" width=8%>
<img width="900" alt="IK-kintai" src="https://user-images.githubusercontent.com/71745650/99880133-dbb6d700-2c54-11eb-8c8f-7c9c7bb5f7e8.png">

# アプリケーション概要
IKという会社の勤怠管理システムをアプリケーション化させたもの
# URL
https://ik-kintai.herokuapp.com/
# テスト用アカウント
氏名：水野雅之  Email：a@a  パスワード：aaaaaa

# 利用方法

# 目指した課題解決
各スタッフ、各院ごとのフォームから送信→各スタッフ１つのフォームから送信  
手入力の必要があった部分も、アプリで勤怠管理の入力をすべて完結させる

# 洗い出した要件
- 打刻漏れがあった際、後からでも日付を指定して入力出来る
- 休憩時間、手当て、施術時間を手入力せずともボタン1つで自動入力する
- 日付、出退勤の時間は入力の手間を端折る為に現時刻ボタン1つで自動入力させる

# 実装した機能についてのGIFと説明
- ユーザー登録機能 ![ログイン・新規登録](https://user-images.githubusercontent.com/71745650/99880557-6ac4ee80-2c57-11eb-9c57-562cd93530b0.gif)
- ユーザー情報/編集/削除　![ユーザー情報閲覧](https://user-images.githubusercontent.com/71745650/99880563-73b5c000-2c57-11eb-82a0-45b08373dd1b.gif)
- rubyファイルからGoogleスプレッドシートに反映
- フォーム送信機能
- 現在時刻反映ボタン

- 休憩時間、手当て、施術時間の自動入力

# 実装予定の機能
- レスポンシブWebデザイン対応
- フォームに備考入力欄の追加
- フォーム送信後、プレビュー又は確認画面遷移ボタン
- 月初にChatWorkで勤怠管理の自動送信

# データベース設計

## users テーブル

| Column         | Type    | Options     |
| -------------- | ------- | ----------- |
| full_part      | boolean | null: false |
| full_name      | string  | null: false |
| affiliation_id | integer | null: false |
| email          | string  | null: false |
| password       | string  | null: false |

### Association
- has_many :attendances

## attendances テーブル

| Column        | Type       | Options                        |
| ------------- | ---------- | ------------------------------ |
| work_place_id | integer    | null: false                    |
| work_days     | date       | null: false                    |
| in_out        | boolean    | null: false                    |
| work_time     | time       | null: false                    |
| carfare       | integer    |                                |
| user          | references | null: false, foreign_key: true |

### Association
- belongs_to :user



# ローカルでの操作方法
