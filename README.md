# Polycon

Proyecto de la materia Taller de Tecnologías de Producción de Software - Ruby
Cursada 2021

## Alumno

* Nombre: Martin Souto
* Legajo: 17297/2
* Email: msouto2001@gmail.com

## Sobre el proyecto

### Estructura 

En adición a la estructura que me fue brindada por la cátedra en el template inicial, decidí crear varios directorios y archivos para organizar la aplicación.

* `lib/polycon/model.rb` es la declaración del namespace "Model", y las directivas de carga de clases y módulos que están contenidos por este.
* `lib/polycon/model/` es el directorio que representa el namespace "Model. En este directorio es donde se encuentran las clases del modelo.
  * `lib/polycon/model/professional.rb` en este archivo se encuentra definida la clase Professional, que representa a un profesional dentro del sistema polycon.
  * `lib/polycon/model/appointment.rb` en este archivo se encuentra definida la clase Appointment, que representa un turno.
  * `lib/polycon/model/exceptions.rb` en este archivo es donde se encuentran definidas las distintas excepciones creadas específicamente para este proyecto.

### Decisiones tomadas

* Las clases Professional y Apointment son las encargadas de realizar el acceso a los archivos, ya sea para crearlos, modificarlos o eliminarlos, asi se evita que haya procesamiento de datos dentro de los archivos del directiorio commands.
* Ante algún problema, estas clases levantan las distintas excepciones con un mensaje especificando el motivo del problema, los archivos del directorio commands, por su parte, se encargan de capturar estas excepciones e informar al usuario cual es el problema de una forma amigable.
* A la hora de crear un nuevo profesional, no importa si se ingresa el nombre con mayúsculas o minúsculas, el sistema guardará a dicho profesional con solo la primer letra del nombre y del apellido en mayúscula. Por ejemplo, si se ingresa "mArTin SOUto" como nombre de profesional, el sistema lo guardará como "Martin Souto".
* Al reservar un nuevo turno, para poder confirmar esta acción el sistema verifica que el profesional indicado no tenga ningún turno ya agendado en el rango de +-10 minutos con respecto a la fecha y hora indicada para el nuevo turno.
