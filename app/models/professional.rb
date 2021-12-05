class Professional < ApplicationRecord

    validates :name, presence: { message: "El profesional debe tener un nombre" }, uniqueness: { message: "El nombre ingresado ya está registrado en el sistema" }, length: { in: 1..50, message: "El nombre debe tener entre 1 y 50 caracteres"}
end
