class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  with_options presence: true do
    validates :full_name, format: { with: /\A[ぁ-んァ-ン一-龥]+\z/, message: 'は全角で入力してください' }
  end
  validates :full_part, inclusion: { in: [true, false]}
  
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :affiliation

  validates :affiliation, presence: true
  validates :affiliation_id, numericality: { other_than: 1, message: 'を選んでください' }

end
