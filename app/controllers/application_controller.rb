class ApplicationController < ActionController::Base
    protect_from_forgery prepend: true

    def has_permission(permi)
        begin
            if ! current_user.roles.all.any? { |rol| rol.permissions.all.any? { |per| per.name == permi} }
                flash[:alert] = "No tienes permiso para acceder a esa página"
                redirect_to home_show_path
                false
            else
                true
            end
        rescue
            flash[:alert] = "No tienes permiso para acceder a esa página"
            redirect_to home_show_path
            false
        end
    end
end
