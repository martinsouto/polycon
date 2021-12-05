class Role < ApplicationRecord

    has_and_belongs_to_many :permissions
    has_and_belongs_to_many :users

    validates :name, presence: true, uniqueness: true

    before_destroy do | role |
        if role.users.count > 0
            role.errors.add( :base, "No se puede eliminar un rol si tiene usuarios asignados")
            throw :abort
        end
    end
end
