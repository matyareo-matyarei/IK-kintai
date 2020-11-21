# アプリケーション名
## IKーkintai  <img src="https://user-images.githubusercontent.com/71745650/98325424-1eac6400-2032-11eb-899c-735967326da2.jpg" width=8%>
<img width="900" alt="IK-kintai" src="https://user-images.githubusercontent.com/71745650/99880133-dbb6d700-2c54-11eb-8c8f-7c9c7bb5f7e8.png">

# アプリケーション概要
IKという会社の勤怠管理システムをアプリケーションで完結させたもの
アプリのフォームで勤怠情報入力→勤怠管理表（Googleスプレッドシート）に反映
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
## ユーザー登録機能  
 フルネーム /  Email / パスワード /  
 所属院 / 雇用形態（常勤か非常勤か）  
![ログイン・新規登録resize](https://user-images.githubusercontent.com/71745650/99881247-f8a2d880-2c5b-11eb-8980-bcdc61cf10b2.gif)

## ユーザー情報/編集/削除
- スタッフの状況変更に合わせて編集可能  
フルネーム / Email / 所属院 / 雇用形態（常勤か非常勤か）  
![ユーザー編集:削除resize](https://user-images.githubusercontent.com/71745650/99881252-fe98b980-2c5b-11eb-8fc5-d1796407f588.gif)

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
