class CreateProfessionals < ActiveRecord::Migration[6.1]
  def change
    create_table :professionals do |t|
      t.string :name, null: false, limit: 50

      t.timestamps
    end
    add_index :professionals, :name, unique: true
  end
end
