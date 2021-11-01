require 'date'
module Polycon
    module Model
        class Appointment
            attr_accessor :name, :surname, :phone, :notes
            attr_reader :date
            def initialize(date, name, surname, phone, notes=nil)
                @date = date
                @name = name
                @surname = surname
                @phone = phone
                @notes = notes
            end

            def to_s
                "#{@date.strftime("%d/%m/%Y %H:%M")} #{@name} #{@surname} #{@phone} #{@notes}"
            end

            def self.create(date, prof, name, surname, phone, notes=nil)
                profesional = Professional.from_file(prof)
                date_obj = DateTime.strptime("#{date}-03:00", "%Y-%m-%d %H:%M%z")
                appointment = self.new(date_obj, name, surname, phone, notes)
                raise Exceptions::PastAppointment, "No se puede crear el turno ya que la fecha es pasada" if !appointment.is_future?
                raise Exceptions::CreationError, "El profesional no puede agregar el turno ya que está ocupado en esa fecha y hora" if !profesional.is_available?(date_obj)
                appointment.save(self.route(prof, date))
                profesional.add_appointment(appointment)
                appointment
            end

            def self.from_file(prof,date)
                raise Exceptions::ProfessionalNotFound, "El profesional especificado no existe" if !Professional.exist?(prof)
                begin
                    #date_obj = DateTime.strptime(self.format_date(date), "%Y-%m-%d %H:%M")
                    date_obj = DateTime.strptime("#{date}-03:00", "%Y-%m-%d_%H-%M%z")
                rescue
                    date_obj = DateTime.strptime("#{date}-03:00", "%Y-%m-%d %H:%M%z")
                end
                raise Exceptions::AppointmentNotFound , "El turno especificado para este profesional no existe" if !self.exist?(prof,date)
                ruta = self.route(prof,date)
                file_data = File.readlines(ruta).map {|l| l.chomp}
                file_data.unshift(date_obj)
                self.new(*file_data)
            end

            def self.exist?(prof,date)
                File.exist?(self.route(prof,date))                    
            end

            def self.route(prof,date)
                "#{Professional.route(prof)}/#{date.tr(" ","_").tr(":","-")}.paf"
            end

            def self.list(prof,date=nil)
                raise Exceptions::ProfessionalNotFound, "El profesional especificado no existe" if !Professional.exist?(prof)
                entries = Dir.entries(Professional.route(prof))
                appoints = entries.select {|each| each != "." && each != ".."}
                appoints.map {|each| self.from_file(prof,File.basename(each,'.paf'))}.select {|each| date==nil || (each.date.to_date == Date.strptime(date, "%Y-%m-%d"))}
            end

            def self.cancel(prof,date)
                appointment = self.from_file(prof,date)
                raise Exceptions::PastAppointment, "No se pueden cancelar turnos pasados" if !appointment.is_future?
                File.delete(self.route(prof,date))
            end

            def self.cancel_all(prof)
                raise Exceptions::ProfessionalNotFound, "El profesional especificado no existe" if !Professional.exist?(prof)
                entries = Dir.entries(Professional.route(prof))
                apps_array = entries.select {|each| each != "." && each != ".."}
                future_apps = apps_array.select {|each| self.from_file(prof,File.basename(each,'.paf')).is_future? }
                raise StandardError, "El profesional indicado no tiene turnos a futuro" if future_apps.empty?
                future_apps.each {|file| File.delete(self.route(prof,File.basename(file,'.paf')))}
            end

            def self.edit(prof,date,options)
                appointment = self.from_file(prof,date)
                raise Exceptions::PastAppointment, "No puedes editar un turno pasado" if !appointment.is_future?
                options.each do |key,value|
                    appointment.send(:"#{key}=",value)
                end
                appointment.save(self.route(prof,date))
            end

            def self.reschedule(old_date,new_date,prof)
                professional = Professional.from_file(prof)
                appointment = self.from_file(prof,old_date)
                new_date_obj = DateTime.strptime("#{new_date}-03:00", "%Y-%m-%d %H:%M%z")
                raise Exceptions::PastAppointment, "No se puede reprogramar un turno pasado" if !appointment.is_future?
                raise Exceptions::PastAppointment, "No se puede reprogramar el turno para una fecha anterior a la actual" if new_date_obj<DateTime.now
                raise Exceptions::ReschedulingError, "No se puede reprogramar el turno ya que es profesional no está disponible en la fecha indicada" if !professional.is_available?(new_date_obj)
                FileUtils.mv(self.route(prof,old_date),self.route(prof,new_date))
            end

            def is_future?
                @date > DateTime.now
            end

            def save(path)
                File.open(path,'w') do |f|
                    f << "#{@name}\n"
                    f << "#{@surname}\n"
                    f << "#{@phone}\n"
                    f << "#{@notes}\n"
                end
            end

            def self.grid_day2(date, prof=nil)#obsolete
                if !prof
                    profs = Professional.list
                    hash = profs.reduce({}) {|dic, pro| dic.update( pro.name => pro.appointments_from_day(date) )}
                else
                    profe = Professional.from_file(prof)
                    hash = {profe.name => profe.appointments_from_day(date)}
                end
                Utils::Export.create_grid_day(date, hash, prof) 
            end


            def self.grid_day(date, prof=nil)
                array = []
                if !prof
                    profs = Professional.list
                    profs.each do |pro|
                        pro.appointments_from_day(date).each { |app| array << [pro.name, app]}
                    end
                else
                    profe = Professional.from_file(prof)
                    profe.appointments_from_day(date).each { |app| array << [profe.name, app]}
                end
                Utils::Export.create_grid_day(date, array, prof) 
            end    
            
            def is_on_day?(date)
                @date.to_date == Date.strptime(date, "%Y-%m-%d")
            end

        end
    end
end