require 'rails_helper'
RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context '新規登録がうまくいく時' do
      it 'full_name]と[emailとpassword]、[password_confirmation]、[full_part]、[affiliation_id]が存在していれば登録できる' do
        expect(@user).to be_valid
      end
      it 'full_nameが全角入力で登録できる' do
        @user.full_name = "ああああ"
        expect(@user).to be_valid
      end

    end

    context 'ユーザー新規登録がうまくいかない時' do
      it "full_name]が空だと登録できない" do
        @user.full_name = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("フルネームを入力してください")
      end

      it 'full_nameは、全角（漢字・ひらがな・カタカナ）での入力でないと登録できない' do
        @user.full_name = 'aaa'
        @user.valid?
        expect(@user.errors.full_messages).to include('フルネームは全角で入力してください')
      end
  
      it "email]が空では登録できない" do
        @user.email = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Eメールを入力してください")
      end

      it 'emailが既に登録されているものと重複すると登録できない' do
        @user.save
        another_user = FactoryBot.build(:user, email: @user.email)
        another_user.valid?
        expect(another_user.errors.full_messages).to include('Eメールはすでに存在します')
      end
  
      it 'emailに＠を含んでいないと登録できない' do
        @user.email = 'aaa'
        @user.valid?
        expect(@user.errors.full_messages).to include('Eメールは不正な値です')
      end
  
      it "password]が空では登録できない" do
        @user.password = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワードを入力してください")
      end

      it 'passwordが６文字以上でないと登録できない' do
        @user.password = 'hoge1'
        @user.password_confirmation = 'hoge1'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは6文字以上で入力してください')
      end
  
      it "password]と[password_confirmation]が一致しないと登録できない" do
        @user.password_confirmation = "aaa111"
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワード（確認用）とパスワードの入力が一致しません")
      end

      it "full_part]が空では登録できない" do
        @user.full_part = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("常勤/非常勤を選んでください")
      end
      
      it "affiliation_id]が空では登録できない" do
        @user.affiliation_id = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("所属を選んでください")
      end
    end
  end
end
