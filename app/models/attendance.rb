class Attendance < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :work_place
  validates :work_place, presence: true
  validates :work_place_id, numericality: { other_than: 1, message: 'を選んでください' }

  validates :work_days, presence: true
  validates :work_time, presence: true

  validates :in_out, inclusion: { in: [true, false], message: 'を選んでください' }
  validates :carfare, numericality: { only_integer: true, message: 'は半角数字で入力してください' }, allow_blank: true

  belongs_to :user
end
