module UsersHelper
    def has_permission(permi)
        begin
            return ( current_user.roles.all.any? { |rol| rol.permissions.all.any? { |per| per.name == permi} } )
        rescue
            return false
        end
    end
end
