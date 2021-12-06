# Polycon

Proyecto de la materia Taller de Tecnologías de Producción de Software - Ruby
Cursada 2021

## Alumno

* Nombre: Martin Souto
* Legajo: 17297/2
* Email: msouto2001@gmail.com

## Entrega 1

### Estructura 

En adición a la estructura que me fue brindada por la cátedra en el template inicial, decidí crear varios directorios y archivos para organizar la aplicación.

* `lib/polycon/model.rb` es la declaración del namespace "Model", y las directivas de carga de clases y módulos que están contenidos por este.
* `lib/polycon/model/` es el directorio que representa el namespace "Model". En este directorio es donde se encuentran las clases del modelo.
  * `lib/polycon/model/professional.rb` en este archivo se encuentra definida la clase Professional, que representa a un profesional dentro del sistema polycon.
  * `lib/polycon/model/appointment.rb` en este archivo se encuentra definida la clase Appointment, que representa un turno.
  * `lib/polycon/model/exceptions.rb` en este archivo es donde se encuentran definidas las distintas excepciones creadas específicamente para este proyecto.

### Decisiones tomadas

* Las clases Professional y Apointment son las encargadas de realizar el acceso a los archivos, ya sea para crearlos, modificarlos o eliminarlos, asi se evita que haya procesamiento de datos dentro de los archivos del directiorio commands.
* Ante algún problema, estas clases levantan las distintas excepciones con un mensaje especificando el motivo del problema, los archivos del directorio commands, por su parte, se encargan de capturar estas excepciones e informar al usuario cual es el problema de una forma amigable.
* A la hora de crear un nuevo profesional, no importa si se ingresa el nombre con mayúsculas o minúsculas, el sistema guardará a dicho profesional con solo la primer letra del nombre y del apellido en mayúscula. Por ejemplo, si se ingresa "mArTin SOUto" como nombre de profesional, el sistema lo guardará como "Martin Souto".
* Al reservar un nuevo turno, para poder confirmar esta acción el sistema verifica que el profesional indicado no tenga ningún turno ya agendado en el rango de +-10 minutos con respecto a la fecha y hora indicada para el nuevo turno.

## Entrega 2

### Estructura 

Tomando como base la estructura generada en la entrega 1, decidí crear un nuevo archivo y directorio para poder completar esta nueva entrega.

* `lib/polycon/utils.rb` es la declaración del namespace "Utils", y las directivas de carga de clases y módulos que están contenidos por este.
* `lib/polycon/utils/` es el directorio que representa el namespace "Utils". En este directorio se encuentran las clases que no corresponden al modelo, pero son utilizadas por este para llevar a cabo ciertas operaciones.
 * `lib/polycon/utils/export.rb` en este archivo se encuentra definida la clase Export, que se encarga de crear las grillas y almacenarlas en archivos de tipo HTML.

### Decisiones tomadas

* Para poder generar las grillas se utiliza ERB (Embedded RuBy), que es un sistema de plantillas que incorpora Ruby en un documento de texto y permite incrustar código Ruby en documentos HTML.
* Los archivos generados se guardan en la carpeta .polycon-grids dentro del home del usuario, esta carpeta es creada si no existe.
* El comando para generar una grilla con los turnos en un día particular se llama "grid-day", el nombre del archivo generado será la fecha pasada por parámetro, y si además se elige filtrar por un profesinal el nombre del archivo será el profesional mas la fecha. Por ejemplo, si se ingresa 'grid-day "2021-11-03"', entonces el archivo se llamará "2021-11-03.html". A su vez, si se ingresa 'grid-day "2021-11-03" --professional="Alma Estevez"', el nombre del archivo será "Alma-Estevez_2021-11-03.html". Estos archivos se guardan en la carpeta "day" dentro de ".polycon-grids".
* El comando para generar una grilla con los turnos en una semana particular se llama "grid-week", para nombrar el archivo se siguen las mismas pautas que en el comando "grid-day", solo que la fecha utilizada no será la pasada en el comando, sino la fecha del primer día (lunes) de la semana correspondiente a la fecha pasada por parámetro. Estos archivos se guardan en la carpeta "week" dentro de ".polycon-grids".
* En cuanto a las asunciones que se permiten hacer en esta entrega, decidí seguir la que indica que las grillas muestren la información en bloques de duración fija (cada 30 minutos), pero los turnos no van a durar el total del tiempo del bloque necesariamente. Los turnos de un mismo profesional podrían llegar a solaparse en un mismo bloque ya que se sigue lo hecho en la entrega 1 que indicaba que a la hora de reservar un turno el sistema verifica que el profesional indicado no tenga ningún turno ya agendado en el rango de +-10 minutos con respecto a la fecha y hora indicada para el nuevo turno. Y por último los turnos se pueden dar en cualquier horario, no solo en los horarios de comiezo de los bloques (por eso para cada turno mostrado en la grilla se muestra también su hora de inicio).

## Entrega 3

### Estructura

Para esta entrega, al pasar de una aplicación manejada por comandos a una aplicación web, la estructura de la misma cambió totalmente. Debí borrar todas las carpetas y archivos que se tenían hasta el momento, para suplantarlos con la estructura generada por rails.

### Decisiones tomadas

* Comenzamos por los usuarios, para su autenticación utilicé la gema Devise, la cual me facilitó notoriamente la tarea de verificar en que páginas los usuarios debían estar autenticados y en cuales no. A su vez mediante esta gema implementé el log in de la página. Devise no probee un index para manejar a los usuarios, que es una de las funcionalidades de los usuarios con rol de administración, por lo que debí generar sin utilizar gemas esta vista.
* Los roles y permisos los creé siguiendo el esquema aprendido en materias anteriores, en el cual usuarios y roles tienen una relacion muchos a muchos, y roles y permisos tienen otra relación muchos a muchos, lo que permite más dinamismo a la hora de cambiar el rol de un usuario y designar los permisos que tiene cada rol. Igualmente, desde la aplicación no se pueden crear ni roles ni permisos, ni tampoco modificar los permisos que tienen los roles que vienen en el seed. El administrador es el único que puede cambiar el rol de otro usuario, pero nadie puede cambiar su propio rol.
* En el archivo seeds.db genero todos los permisos, se los asigno a los tres roles que fueron especificados en el enunciado (adminstracion, asistencia y consulta) y creo tres usuarios, uno para cada rol. Estos son admin@gmail.com, asist@gmail.com y consul@gmail.com, la contraseña de todos es "123123".
* A la hora de crear las tablas de profesionales y turnos decidí que entre ellos habría una relacion uno a muchos, donde el turno le pertenece a un profesional y un profesional tiene muchos turnos.
* En cuanto a las rutas, las rutas de los turnos están anidadas dentro de las de profesionales, esto quiere decir que no hay un index de todos los turnos, sino que hay un index separado para los turnos de cada profesional, hacerlo de esta forma me pareció mas ordenado.
* Para la funcionalidad de exportar las grillas decidí no cambiar de lo hecho en la entrega anterior, las grillas se siguen guardando en la carpeta .polycon-grids dentro del home del usuario, y a su vez esta carpeta se divide en day y week, para separar los archivos correspondientes a las grillas diarias de las semanales.
* Un cambio con respecto a la funcionalidad implementada en la primer entrega es que antes un turno no podia guardarse si en un rango de +-10 minutos ese profesional tenia otro turno, ahora un turno solo no podrá guardarse si ya hay un turno con ese profesional en la misma fecha y hora exactamente.
