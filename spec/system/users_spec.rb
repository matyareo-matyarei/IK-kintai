require 'rails_helper'

RSpec.describe "ユーザー新規登録", type: :system do
  before do
    @user = FactoryBot.build(:user)
    @attendance = FactoryBot.build(:attendance)
  end

  context '新規登録できる時' do
    it '正しい情報を入力すれば新規登録ができ、attendance#newのページに移動する' do
      # トップページへいこうとすると、ログイン画面に遷移する
      visit root_path
      expect(current_path).to eq "/users/sign_in"

      # 新規登録ページへ遷移するボタンがある
      expect(page).to have_content('新規登録へ')
      
      # 新規登録ボタンを押して、新規登録ページへ移動する
      click_on '新規登録へ'
      
      # ユーザー情報を入力する
      fill_in 'full_name', with: @user.full_name
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      fill_in 'password-confirmation', with: @user.password_confirmation
      choose '常勤'
      select '千束', from: 'user_affiliation_id'
      
      # 社員登録ボタンを押すとユーザーモデルのカウントが1上がる
      expect{click_on '社員登録'}.to change { User.count}.by(1)
      
      # 勤怠入力(attendance#new)画面へ遷移する
      expect(current_path).to eq root_path
      
      # ログアウトボタンが表示されている
      expect(page).to have_content('ログアウト')
      
      # ログインボタンや新規登録ボタンが表示されていない
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end

  end

  context '新規登録できない時' do
    it '誤った情報では新規登録ができず、新規登録ページへ戻ってくる' do
      # トップページへいこうとすると、ログイン画面に遷移する
      # 新規登録ページへ遷移するボタンがある
      # 新規登録ページへ移動する
      # ユーザー情報を入力する
      # 社員登録ボタンを押してもユーザーモデルのカウントは1上がらない
      # 新規登録ページへ戻される
    end
  end
end
