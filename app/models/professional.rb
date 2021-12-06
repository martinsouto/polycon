class Professional < ApplicationRecord
    has_many :appointments

    validates :name, presence: { message: "El profesional debe tener un nombre" }, uniqueness: { message: "El nombre ingresado ya está registrado en el sistema" }, length: { in: 1..50, message: "El nombre debe tener entre 1 y 50 caracteres"}

    before_destroy do | professional |
        if professional.appointments.futures.count > 0
            professional.errors.add( :base, "El profesional seleccionado tiene turnos a futuro, por lo que no puede eliminarse")
            throw :abort
        else
            professional.appointments.destroy_all
        end
    end
end
