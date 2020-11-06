# アプリケーション名
IKーkintai  
# アプリケーション概要
IKという会社の勤怠管理システムをアプリケーション化させたものです。  
# URL

# テスト用アカウント

# 利用方法

# 目指した課題解決
アプリで勤怠管理の入力をすべて済ませられる

# 洗い出した要件
- 打刻漏れがあった際
- 休憩時間、手当て、施術時間
- 

# 実装した機能についてのGIFと説明


# 実装予定の機能
- ユーザー登録機能  
- Googleスプレッドシートに反映  
- フォーム送信機能  
- 現在日時反映ボタン  
- ユーザー情報編集  
- フォーム送信後、プレビュー又は確認画面遷移ボタン  
- 休憩時間、手当て、施術時間の自動入力
- 月初にChatWorkで勤怠管理の自動送信

# データベース設計

## users テーブル

| Column      | Type    | Options     |
| ----------- | ------- | ----------- |
| full_part   | boolean | null: false |
| full_name   | string  | null: false |
| affiliation | integer | null: false |
| email       | string  | null: false |
| password    | string  | null: false |

### Association
- has_one :attendance

## attendances テーブル

| Column     | Type       | Options                        |
| ---------- | ---------- | ------------------------------ |
| work_place | integer    | null: false                    |
| work_days  | date       | null: false                    |
| in_time    | time       | null: false                    |
| out_time   | time       | null: false                    |
| carfare    | integer    |                                |
| user       | references | null: false, foreign_key: true |

### Association
- belongs_to :user



# ローカルでの操作方法
