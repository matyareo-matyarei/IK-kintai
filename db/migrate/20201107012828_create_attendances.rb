class CreateAttendances < ActiveRecord::Migration[6.0]
  def change
    create_table :attendances do |t|
      t.integer :work_place_id,    null: false
      t.date :work_days,           null: false
      t.boolean :in_out,           null: false
      t.time :work_time,           null: false
      t.integer :carfare
      t.text :remarks
      t.references :user,       foreign_key: true

      t.timestamps
    end
  end
end
