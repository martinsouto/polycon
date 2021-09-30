require 'fileutils'
module Polycon
    module Model
        class Professional
            attr_accessor :name, :appointments

            def initialize(name, appointments=[])
                @name = name
                @appointments = appointments
            end

            def self.create(name,appointments=[])
                raise StandardError, "Ya existe un profesional con este nombre" if self.exist?(name)
                FileUtils.mkdir("#{PATH}#{name.tr(" ","_")}")
                self.new(name,appointments)
            end

            def route
                "#{PATH}#{@name.tr(" ","_")}"
            end

            def self.list
                
            end

            def from_file(name)
                #returns the Professional object that has the name given(with his appointments -to be done)
            end

            def self.exist?(name)
                Dir.exist?("#{PATH}#{name.tr(" ","_")}")
            end

            def self.rename(old_name,new_name)
                raise StandardError, "Los nombres ingresados no deben ser iguales" if old_name==new_name
                raise StandardError, "El profesional ingresado no existe" if !self.exist?(old_name)
                raise StandardError, "El nuevo nombre ya le pertenece a un profesional" if self.exist?(new_name)
                #prof = self.from_file(old_name)
                #prof.name(new_name)
                FileUtils.mv("#{PATH}#{old_name.tr(" ","_")}","#{PATH}#{new_name.tr(" ","_")}")
                #prof seguir viendo este tema, capaz ni traigo a prof ya que en realidad esto
                #mismo se puede hacer llamando al accesor name cuando no haga falta persistir en archs
            end
        end
    end
end