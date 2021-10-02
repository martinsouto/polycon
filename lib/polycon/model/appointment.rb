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

            def self.create(date, prof, name, surname, phone, notes)
                profesional = Profesional.from_file(prof)
                date_obj = DateTime.strptime(date, "%Y-%m-%d %H:%M")
                raise StandardError, "El profesional no puede agregar el turno ya que está ocupado en esa fecha" if !profesional.is_available?(date_obj)
                #self.save(date, prof, name, surname, phone, notes)
                appointment = self.new(date_obj, name, surname, phone, notes)
                profesional.add_appointment(appointment)
                appointment
            end

            def self.from_file(prof,date)
                raise StandardError, "El profesional especificado no existe" if !Professional.exist?(prof)
                begin
                    date_obj = DateTime.strptime(self.format_date(date), "%Y-%m-%d %H:%M")
                rescue
                    date_obj = DateTime.strptime(date, "%Y-%m-%d %H:%M")
                end
                raise StandardError, "El turno especificado para este profesional no existe" if !self.exist?(prof,date)
                ruta = self.route(prof,date)
                file_data = File.readlines(ruta).map {|l| l.chomp}
                file_data.unshift(date_obj)
                self.new(*file_data)
            end

            def self.format_date(date)
                arr = date.split('_')
                "#{arr[0]} #{arr[1].tr("-",":")}"
            end

            def self.exist?(prof,date)
                File.exist?(self.route(prof,date))                    
            end

            def self.route(prof,date)
                "#{Professional.route(prof)}/#{date.tr(" ","_").tr(":","-")}.paf"
            end

            def self.list(prof,date=nil)
                raise StandardError, "El profesional especificado no existe" if !Professional.exist?(prof)
                entries = Dir.entries(Professional.route(prof))
                appoints = entries.select {|each| each != "." && each != ".."}
                appoints.map {|each| self.from_file(prof,File.basename(each,'.paf'))}.select {|each| date==nil || (each.date.to_date == Date.strptime(date, "%Y-%m-%d"))}
            end

            def self.cancel(prof,date)
                appointment = self.from_file(prof,date)
                raise StandardError, "No se pueden cancelar turnos pasados" if !appointment.is_future?
                File.delete(self.route(prof,date))
            end

            def self.cancel_all(prof)
                raise StandardError, "El profesional especificado no existe" if !Professional.exist?(prof)
                entries = Dir.entries(Professional.route(prof))
                apps_array = entries.select {|each| each != "." && each != ".."}
                future_apps = apps_array.select {|each| self.from_file(prof,File.basename(each,'.paf')).is_future? }
                raise StandardError, "El profesional indicado no tiene turnos a futuro" if future_apps.empty?
                future_apps.each {|file| File.delete(self.route(prof,File.basename(file,'.paf')))}
            end

            def self.edit(prof,date,options)
                appointment = self.from_file(prof,date)
                raise StandardError, "No puedes editar un turno pasado" if !appointment.is_future?
                options.each do |key,value|
                    appointment.send(:"#{key}=",value)
                end
                appointment.save(self.route(prof,date))
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

        end
    end
end