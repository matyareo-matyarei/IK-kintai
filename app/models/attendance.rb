class Attendance < ApplicationRecord
  with_options presence: true do
    validates :work_days
    validates :work_time
  end
  
  validates :in_out, inclusion: { in: [true, false]}
  validates :carfare, numericality: { message: 'は半角数字で入力してください' }
  
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :work_place
  validates :work_place, presence: true
  validates :work_place_id, numericality: { other_than: 1, message: 'を選んでください' }
  
  belongs_to :user

end
