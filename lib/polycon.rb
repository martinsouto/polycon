require 'fileutils'
module Polycon
  PATH = "#{File.expand_path('~')}/.polycon/"
  PATH2 = "#{File.expand_path('~')}/.polycon-grids/"
  autoload :VERSION, 'polycon/version'
  autoload :Commands, 'polycon/commands'
  autoload :Model, 'polycon/model'
  autoload :Utils, 'polycon/utils'


  if (!Dir.exist?(PATH)) 
    FileUtils.mkdir PATH
  end

  # Agregar aquí cualquier autoload que sea necesario para que se cargue las clases y
  # módulos del modelo de datos.
  # Por ejemplo:
  # autoload :Appointment, 'polycon/appointment'
end
