class CreateAppointments < ActiveRecord::Migration[6.1]
  def change
    create_table :appointments do |t|
      t.datetime :date, null: false
      t.belongs_to :professional, null: false, foreign_key: true
      t.string :first_name, null:false, limit: 50
      t.string :last_name, null: false, limit: 50
      t.string :phone, null: false, limit: 30
      t.text :notes

      t.timestamps
    end
  end
end
