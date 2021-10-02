require 'fileutils'
module Polycon
    module Model
        class Professional
            attr_accessor :name
            attr_reader :appointments
            def initialize(name, appointments=[])
                @name = name
                @appointments = appointments
            end

            def self.create(name,appointments=[])
                name = self.format_name(name)
                raise StandardError, "Ya existe un profesional con este nombre" if self.exist?(name)
                FileUtils.mkdir("#{PATH}#{name.tr(" ","_")}")
                self.new(name,appointments)
            end

            def self.format_name(name)
                name.split.map(&:capitalize).join(' ')
            end

            def self.route(name)
                "#{PATH}#{self.format_name(name).tr(" ","_")}"
            end

            def self.list
                entries = Dir.entries(PATH)
                prof_array = entries.select {|each| each != "." && each != ".."}
                raise StandarError, "No hay profesionales cargados" if prof_array.empty?
                prof_array.map  {|each| self.from_file(each.tr("_"," "))}
            end

            def self.from_file(name)
                #returns the Professional object that has the name given(with his appointments)
                name = self.format_name(name)
                raise StandardError, "El profesional específicado no existe" if !self.exist?(name)
                #traigo un arreglo de sus appointments
                appointments = Appointment.list(name)
                professional = self.new(name.tr("_"," "),appointments)
            end

            def self.exist?(name)
                name = self.format_name(name)
                Dir.exist?("#{PATH}#{name.tr(" ","_")}")
            end

            def self.rename(old_name,new_name)
                old_name = self.format_name(old_name)
                new_name = self.format_name(new_name)
                raise StandardError, "Los nombres ingresados no deben ser iguales" if old_name==new_name
                raise StandardError, "El profesional ingresado no existe" if !self.exist?(old_name)
                raise StandardError, "El nuevo nombre ya le pertenece a un profesional" if self.exist?(new_name)
                prof = self.from_file(old_name)
                prof.name=(new_name)
                FileUtils.mv("#{PATH}#{old_name.tr(" ","_")}","#{PATH}#{new_name.tr(" ","_")}")
                prof
            end

            def self.delete(name)
                profesional = self.from_file(name)
                raise StandardError, "El profesional no puede ser eliminado ya que tiene turnos futuros" if profesional.has_future_appointments?
                FileUtils.rm_rf("#{PATH}#{profesional.name.tr(" ","_")}")
            end

            def has_future_appointments?
                @appointments.any? {|each| each.is_future?}
            end

            def future_appointments
                @appointments.select {|each| each.is_future?}
            end

            def is_available?(date)
                #verifica que no tiene ningun turno entre +-10mis de la date pasada
            end

            def add_appointment(app)
                @appointments << app
            end
        end
    end
end