# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

User.destroy_all
Role.destroy_all
Permission.destroy_all

#Se crean los permisos
user_index = Permission.create(name: "user_index")
user_show = Permission.create(name: "user_show")
user_new = Permission.create(name: "user_new")
user_update = Permission.create(name: "user_update")
user_destroy = Permission.create(name: "user_destroy")

professional_index = Permission.create(name: "professional_index")
professional_show = Permission.create(name: "professional_show")
professional_new = Permission.create(name: "professional_new")
professional_update = Permission.create(name: "professional_update")
professional_destroy = Permission.create(name: "professional_destroy")

appointment_index = Permission.create(name: "appointment_index")
appointment_show = Permission.create(name: "appointment_show")
appointment_new = Permission.create(name: "appointment_new")
appointment_update = Permission.create(name: "appointment_update")
appointment_destroy = Permission.create(name: "appointment_destroy")

#Se crean los roles
consul = Role.create(name: "consulta")
asist = Role.create(name: "asistencia")
admin = Role.create(name: "administracion")

#Se le asignan los permisos correspondientes a cada rol
consul.permissions << [professional_index, professional_show, appointment_index, appointment_show]
asist.permissions << [professional_index, professional_show, appointment_index, appointment_show, appointment_new, appointment_update, appointment_destroy]
admin.permissions << [appointment_index, appointment_show, appointment_new, appointment_update, appointment_destroy, professional_index, professional_show, professional_new, professional_update, professional_destroy, user_index, user_show, user_new, user_update, user_destroy]

#Se crean los usuarios
usuario1 = User.create(email: "admin@gmail.com", password: "123123", password_confirmation: "123123")
usuario2 = User.create(email: "asist@gmail.com", password: "123123", password_confirmation: "123123")
usuario3 = User.create(email: "consul@gmail.com", password: "123123", password_confirmation: "123123")

#Se asignan los roles a los usuarios
usuario1.roles << admin
usuario2.roles << asist
usuario3.roles << consul
