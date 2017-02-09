# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Type.create([{ name:'Kuliah'}, { name:'Workshop'}, { name:'Keperluan Lab'}, { name:'Praktikum'}, { name:'Himpunan'}])
User.create([{ name:'lp', hp:'', nrp_nip:'', password:'123321', is_admin:1, email:'lp@if.its.ac.id'},
             { name:'Ardi Nusawan Adjust', hp:'081999776267', nrp_nip:'5113100096', password:'123321', is_admin:1, email:'ardi.nusawan13@gmail.com'},
             { name:'umum', hp:'0123456789', nrp_nip:'51646464646', password:'enter-umum', is_admin:0, email:'lol@if.its.ac.id'}])
Booking.create([{ title:'Kelas Progjar D', user_id:1, validation_by:1, type_id:1, description:'Proyektor Harus ada'}])
# Schedule.create([{
#                      :booking_id=>1,
#                      :start=>DateTime.strptime("09/14/2009 8:00", "%m/%d/%Y %H:%M"),
#                      :end=>DateTime.strptime("09/14/2009 8:00", "%m/%d/%Y %H:%M")
#                  },{
#                     :booking_id=>1,
#                     :start=>DateTime.strptime("09/14/2010 8:00", "%m/%d/%Y %H:%M"),
#                     :end=>DateTime.strptime("09/14/2010 8:00", "%m/%d/%Y %H:%M")
#                  }])