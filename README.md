# アプリケーション名

# アプリケーション概要

# URL

# テスト用アカウント

# 利用方法

# 目指した課題解決


# 洗い出した要件

# 実装した機能についてのGIFと説明


# 実装予定の機能


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
| in_out     | boolean    | null: false                    |
| time       | time       | null: false                    |
| carfare    | integer    |                                |
| user       | references | null: false, foreign_key: true |

### Association
- belongs_to :user



# ローカルでの操作方法
