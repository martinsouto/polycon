module Polycon
    module Model
        module Exceptions
            class ProfessionalNotFound < StandardError
            end

            class AppointmentNotFound < StandardError
            end

            class NoAppointments < StandardError
            end

            class PastAppointment < StandardError
            end

            class FutureAppointments < StandardError
            end

            class ExistingProffesional < StandardError
            end

            class RenameError < StandardError
            end

            class CreationError < StandardError
            end
        end
    end
end