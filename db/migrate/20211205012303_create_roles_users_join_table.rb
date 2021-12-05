class CreateRolesUsersJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :roles, :users do |t|
      t.index :role_id
      t.index :user_id
    end
  end
end
