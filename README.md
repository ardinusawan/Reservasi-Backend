# Reservasi Backend Laboratorium Pemrograman I Teknik Informatika ITS Surabaya

This Project is create by My Self.
From Scratch, using scaffold a little bit :D

* Ruby & Rails version
    - ruby 2.3.1p112 (2016-04-26 revision 54768) [x86_64-linux]
    - Rails 5.0.0.1
* System dependencies
  - Ubuntu 16.04 (Prod), Ubuntu Mate 16.04(Dev)
  - MySQL (Dev & Prod)
  - Puma (Dev), Apache2(Prod)
* Configuration
  - Setting u'r DDoS params (im 2 lazy 2 write right now)
  - Setting u'r database in config/database, if sercer in cloud / diff server, add host parameter
* Database creation  
    - rails db:create
* Database initialization
    - rails db:migrate
* How to run the test suite
* Services (job queues, cache servers, search engines, etc.)
* Deployment instructions
  - Bundle install
  - Run : rails s
    - binding : -b, ex rails s -b 0.0.0.0
    - port(default:3000) : -p 8080 ex rails s -p 8080
    - run on background : -d, ex rails s -d
* Auth
  Iam Using JWT, from https://www.sitepoint.com/introduction-to-using-jwt-in-rails/

License : Free! Do What U Want XD