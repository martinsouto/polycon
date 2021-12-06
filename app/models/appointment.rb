class Appointment < ApplicationRecord
  belongs_to :professional

  validates :first_name, presence: { message: "Debe ingresarse el nombre del paciente" }, length: { in: 1..50, message: "El nombre del paciente debe tener entre 1 y 50 caracteres"}
  validates :last_name, presence: { message: "Debe ingresarse el apellido del paciente" }, length: { in: 1..50, message: "El apellido del paciente debe tener entre 1 y 50 caracteres"}
  validates :phone, presence: { message: "Debe ingresarse el teléfono del paciente" }, length: { in: 1..50, message: "El teléfono del paciente debe tener entre 1 y 30 caracteres"}
  #validates :professional, presence: { message: "Debe indicarse a que profesional corresponde el turno"}
  validates :date, presence: { message: "Debe ingresarse una fecha y hora para el turno" }
  validate :futute_date


  def futute_date
    if date && date.past?
      errors.add(:base, "La fecha y hora del turno debe ser en el futuro")
    end
  end

  scope :futures, -> { where("date > ?", DateTime.now) }
end
