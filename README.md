# Polycon

Proyecto de la materia Taller de Tecnologías de Producción de Software - Ruby
Cursada 2021

## Alumno

* Nombre: Martin Souto
* Legajo: 17297/2

## Sobre el proyecto

Para organizar el proyecto decidi crear el directorio "model" dentro del cual se encuentran los archivos correspondientes al modelo de datos de polycon, estos son professional.rb (en el cual se encuentra la clase Professional) appointments.rb (en el cual se encuentra la clase Appointment) y exceptions.rb (que tiene las distintas excepciones creadas específicamente para este proyecto). Las clases Professional y Apointment son las encargadas de realizar el acceso a los archivos, ya sea para crearlos, modificarlos o eliminarlos, asi se evita que haya procesamiento de datos dentro de los archivos del directiorio commands. Ante algún problema, estas clases levantan las distintas excepciones con un mensaje especificando el motivo del problema, los archivos del directorio commands, por su parte, se encargan de capturar estas excepciones e informar al usuario cual es el problema de una forma amigable.
