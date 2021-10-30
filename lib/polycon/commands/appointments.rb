require 'date'
module Polycon
  module Commands
    module Appointments
      class Create < Dry::CLI::Command
        desc 'Create an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: true, desc: "Patient's name"
        option :surname, required: true, desc: "Patient's surname"
        option :phone, required: true, desc: "Patient's phone number"
        option :notes, required: false, desc: "Additional notes for appointment"

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name=Carlos --surname=Carlosi --phone=2213334567'
        ]

        def call(date:, professional:, name:, surname:, phone:, notes: nil)
          begin
            appointment = Model::Appointment.create(date,professional, name, surname, phone, notes)
            warn "El turno con el/la profesional #{professional} en la fecha #{date} fue creado con éxito"
          rescue Date::Error
            warn "La fecha indicada es inválida"
          rescue Model::Exceptions::ProfessionalNotFound, Model::Exceptions::CreationError, Model::Exceptions::PastAppointment=> exception
            warn exception.message
          end
        end

      end

      class Show < Dry::CLI::Command
        desc 'Show details for an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Shows information for the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional:)
          begin
            appointment = Model::Appointment.from_file(professional,date)
            warn appointment.to_s
          rescue Date::Error
            warn "La fecha indicada es inválida"
          rescue Model::Exceptions::ProfessionalNotFound, Model::Exceptions::AppointmentNotFound=> exception
            warn exception.message
          end
        end

      end

      class Cancel < Dry::CLI::Command
        desc 'Cancel an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Cancels the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional:)
          begin
            Model::Appointment.cancel(professional,date)
            warn "Turno cancelado con éxito"
          rescue Date::Error
            warn "La fecha indicada es inválida"
          rescue Model::Exceptions::ProfessionalNotFound, Model::Exceptions::AppointmentNotFound, Model::Exceptions::PastAppointment => exception
            warn exception.message
          end
        end

      end

      class CancelAll < Dry::CLI::Command
        desc 'Cancel all appointments for a professional'

        argument :professional, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez" # Cancels all appointments for professional Alma Estevez',
        ]

        def call(professional:)
          begin
            Model::Appointment.cancel_all(professional)
            warn "Todos los turnos a futuro de #{professional} fueron cancelados"
          rescue Model::Exceptions::ProfessionalNotFound, Model::Exceptions::NoAppointments=> exception 
            warn exception.message
          end
        end

      end

      class List < Dry::CLI::Command
        desc 'List appointments for a professional, optionally filtered by a date'

        argument :professional, required: true, desc: 'Full name of the professional'
        option :date, required: false, desc: 'Date to filter appointments by (should be the day)'

        example [
          '"Alma Estevez" # Lists all appointments for Alma Estevez',
          '"Alma Estevez" --date="2021-09-16" # Lists appointments for Alma Estevez on the specified date'
        ]

        def call(professional:, date: nil)
          begin
            appointments = Model::Appointment.list(professional, date)
            warn appointments.map {|each| each.to_s}
          rescue Date::Error 
            warn "La fecha indicada es inválida"
          rescue Model::Exceptions::ProfessionalNotFound => exception
            warn exception.message
          end
        end

      end

      class Reschedule < Dry::CLI::Command
        desc 'Reschedule an appointment'

        argument :old_date, required: true, desc: 'Current date of the appointment'
        argument :new_date, required: true, desc: 'New date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" "2021-09-16 14:00" --professional="Alma Estevez" # Reschedules appointment on the first date for professional Alma Estevez to be now on the second date provided'
        ]

        def call(old_date:, new_date:, professional:)
          begin
            Model::Appointment.reschedule(old_date,new_date,professional)
            warn "Turno reprogramado con éxito"
          rescue Date::Error 
            warn "La fecha indicada es inválida"
          rescue Model::Exceptions::ProfessionalNotFound, Model::Exceptions::AppointmentNotFound, Model::Exceptions::ReschedulingError, Model::Exceptions::PastAppointment => exception
            warn exception.message
          end
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit information for an appointments'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: false, desc: "Patient's name"
        option :surname, required: false, desc: "Patient's surname"
        option :phone, required: false, desc: "Patient's phone number"
        option :notes, required: false, desc: "Additional notes for appointment"

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" # Only changes the patient\'s name for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" --surname="New surname" # Changes the patient\'s name and surname for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --notes="Some notes for the appointment" # Only changes the notes for the specified appointment. The rest of the information remains unchanged.',
        ]

        def call(date:, professional:, **options)
          begin
            Model::Appointment.edit(professional,date,options)
            warn "Turno editado con éxito"
          rescue Date::Error 
            warn "La fecha indicada es inválida"
          rescue Model::Exceptions::ProfessionalNotFound, Model::Exceptions::AppointmentNotFound, Model::Exceptions::PastAppointment => exception
            warn exception.message
          end
        end

      end

      class GridDay < Dry::CLI::Command
        desc 'Generate grid file of appointments for a given day'

        argument :date, required: true, desc: 'Date that will be used to generate the grid'
        option :professional, required: false, desc: 'Professional to filter the appointments'

        example [
          '"2021-09-16" # Creates a grid that shows every professional`s appointments whose date is 2021-09-16',
          '"2021-09-16" --professional="Alma Estevez" # Creates a grid that shows all Alma Estevez`s appointments whose date is 2021-09-16'
        ]

        def call(date:, professional: nil)
          res = Model::Appointment.grid_day(date,professional)
          warn res
          res.each do |key, value|
            warn "#{key}:"
            value.each { |each| warn "#{each.name} #{each.surname}"}
            warn "----"
          end
        end

      end

      class GridWeek < Dry::CLI::Command
        desc 'Generate grid file of appointments for a week'

        argument :date, required: true, desc: 'Date of the week that will be used to generate the grid'
        option :professional, required: false, desc: 'Professional to filter the appointments'

        example [
          '"2021-09-16" # Creates a grid that shows every professional`s appointments whose date is in the same week that 2021-09-16',
          '"2021-09-16" --professional="Alma Estevez" # Creates a grid that shows all Alma Estevez`s appointments whose date is in the same week that 2021-09-16'
        ]

        def call(date:, professional: nil)
          warn "TODO: implementar este otro comando"
        end

      end
    end
  end
end
