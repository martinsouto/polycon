class CreatePermissionsRolesJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :permissions, :roles do |t|
      t.index :permission_id
      t.index :role_id
    end
  end
end
