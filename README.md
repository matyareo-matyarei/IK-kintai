# アプリケーション名
## IKーkintai  <img src="https://user-images.githubusercontent.com/71745650/98325424-1eac6400-2032-11eb-899c-735967326da2.jpg" width=8%>
<img width="900" alt="IK-kintai" src="https://user-images.githubusercontent.com/71745650/99880133-dbb6d700-2c54-11eb-8c8f-7c9c7bb5f7e8.png">

# アプリケーション概要
IKという会社の勤怠管理システムをアプリケーションで完結させたもの  
アプリのフォームで勤怠情報入力→勤怠管理表（Googleスプレッドシート）に反映  
2020年11月〜試験的に鍼灸整骨院スタッフに導入中
# URL
https://ik-kintai.herokuapp.com/
# テスト用アカウント
氏名：テスト  Email：a@a  パスワード：aaaaaa

# 利用方法

# 目指した課題解決
各スタッフ、各院ごとのフォームから送信→各スタッフ１つのフォームから送信  
手入力の必要があった部分も、アプリで勤怠管理の入力をすべて完結させる

# 洗い出した要件
- 打刻漏れがあった際、後からでも日付を指定して入力出来る
- 休憩時間、手当て、施術時間を手入力せずともボタン1つで自動入力する
- 日付、出退勤の時間は入力の手間を端折る為に現時刻ボタン1つで自動入力させる

# 実装した機能についてのGIFと説明
### ユーザー登録機能  
 フルネーム /  Email / パスワード /  
 所属院 / 雇用形態（常勤か非常勤か）  
![ログイン・新規登録resize](https://user-images.githubusercontent.com/71745650/99881247-f8a2d880-2c5b-11eb-8980-bcdc61cf10b2.gif)

### ユーザー情報/編集/削除  
 スタッフの状況変更に合わせて編集可能  
フルネーム / Email / 所属院 / 雇用形態（常勤か非常勤か）  
![ユーザー編集:削除resize](https://user-images.githubusercontent.com/71745650/99881252-fe98b980-2c5b-11eb-8fc5-d1796407f588.gif)

### フォーム送信機能
フォームで送信する情報  
勤務場所 / 勤務日（日付）/ 出勤か退勤か / 時刻 / 交通費 / 備考  

・使用するユーザーがフォームを送信すれば、上記の勤怠情報がスプレッドシートに入力される  
※正しく入力されていないと送信されないよう、バリデーションを組んでいる（日本語で表示）  
![フォーム送信resize](https://user-images.githubusercontent.com/71745650/99881955-520d0680-2c60-11eb-9137-8fa30bdcdf7e.gif)


### 勤怠入力履歴確認＋削除機能  
 打刻漏れを防ぐ為、フォームの送信履歴をユーザーは確認、削除できる  
 <img width="300" src="https://user-images.githubusercontent.com/71745650/99881620-2557ef80-2c5e-11eb-8f02-9c2568f76d4e.png">


### 現在時刻反映ボタン  
 入力の手間を省く為、現時刻ボタンを押すと「日付」「時刻」が入力される  
![現時刻入力resize](https://user-images.githubusercontent.com/71745650/99892118-e608bd80-2cb4-11eb-81da-517041837a33.gif)

### 休憩時間、手当て、施術時間の自動入力  
 フォームの下にある補助入力ボタンを押すと以下が全て入力される  
- 休憩時間（出退勤の差が8h以上で1:00付加）
- 手当  
（非常勤で日/祝 最大→800円、土→400円）  
  営業時間(10:00~19:00)のうち、日祝：1h×¥100 or 土：1h×¥50  
- 施術時間（非常勤で3院分の日報に入力されている施術時間を入力）  
![補助入力resize](https://user-images.githubusercontent.com/71745650/99892014-91187780-2cb3-11eb-8c49-4ea6e1bddae5.gif)


# 実装予定の機能
### レスポンシブWebデザイン対応
### フォーム送信後、プレビュー又は確認画面遷移ボタン
### 勤怠入力完了をLINEで送信
### 月をまたいだ時の入力の分岐

# データベース設計
<img width="566" alt="ik-kintai ER図" src="https://user-images.githubusercontent.com/71745650/100961056-ef234580-3564-11eb-8b42-b433b96f72bf.png">

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
| remarks       | text       |                                |
| user          | references | null: false, foreign_key: true |

### Association
- belongs_to :user



# ローカルでの操作方法
```
% git clone https://github.com/matyareo-matyarei/IK-kintai.git
```
