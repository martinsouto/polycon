module Polycon
  module Commands
    module Professionals
      class Create < Dry::CLI::Command
        desc 'Create a professional'

        argument :name, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez"      # Creates a new professional named "Alma Estevez"',
          '"Ernesto Fernandez" # Creates a new professional named "Ernesto Fernandez"'
        ]

        def call(name:, **)
          begin
            professional = Model::Professional.create(name)
            warn "Profesional #{professional.name} creado con éxito"
          rescue Model::Exceptions::CreationError => exception
            warn exception.message
          end
        end

      end

      class Delete < Dry::CLI::Command
        desc 'Delete a professional (only if they have no appointments)'

        argument :name, required: true, desc: 'Name of the professional'

        example [
          '"Alma Estevez"      # Deletes a new professional named "Alma Estevez" if they have no appointments',
          '"Ernesto Fernandez" # Deletes a new professional named "Ernesto Fernandez" if they have no appointments'
        ]

        def call(name: nil)
          begin
            Model::Professional.delete(name)
            warn "Profesional #{name} eliminado"
          rescue Model::Exceptions::ProfessionalNotFound, Model::Exceptions::FutureAppointments => exception
            warn exception.message
          end
        end

      end

      class List < Dry::CLI::Command
        desc 'List professionals'

        example [
          "          # Lists every professional's name"
        ]

        def call(*)
          begin
            professionals = Model::Professional.list
            warn professionals.map {|p| p.name}
          rescue Model::Exceptions::NoProfessionals => exception
            warn exception.message
          end
        end

      end

      class Rename < Dry::CLI::Command
        desc 'Rename a professional'

        argument :old_name, required: true, desc: 'Current name of the professional'
        argument :new_name, required: true, desc: 'New name for the professional'

        example [
          '"Alna Esevez" "Alma Estevez" # Renames the professional "Alna Esevez" to "Alma Estevez"',
        ]

        def call(old_name:, new_name:, **)
          begin
            professional = Model::Professional.rename(old_name,new_name)
            warn "Nombre modificado con éxito, #{old_name} ahora se llama #{professional.name}"
          rescue Model::Exceptions::RenameError, Model::Exceptions::ProfessionalNotFound => exception
            warn exception.message
          end
        end

      end
    end
  end
end
