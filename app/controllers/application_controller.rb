class ApplicationController < ActionController::Base
    protect_from_forgery prepend: true

    def has_permission(permi)
        begin
            if ! current_user.roles.all.any? { |rol| rol.permissions.all.any? { |per| per.name == permi} }
                flash[:alert] = "#{current_user.roles.first.permissions.first.name} No tienes permiso para acceder a esa página"
                redirect_to home_show_path
            end
        rescue
            flash[:alert] = "#{current_user.email} no tienes permiso para acceder a esa página"
            redirect_to home_show_path
        end
    end
end
