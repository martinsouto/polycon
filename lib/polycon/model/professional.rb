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
                raise StandardError, "Ya existe un profesional con este nombre" if Dir.exist?("#{PATH}#{name.tr(" ","_")}")
                FileUtils.mkdir("#{PATH}#{name.tr(" ","_")}")
                self.new(name,appointments)
            end

            def route
                "#{PATH}#{@name.tr(" ","_")}"
            end

            def self.list
                
            end
        end
    end
end