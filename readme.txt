# nginx     : ip=10.88.0.10 external_port=80
# guacamole : ip=10.88.0.11 internal_port=8080
# guacd     : ip=10.88.0.12 internal_port=4822
# etherpad  : ip=10.88.0.13 internal_port=9001
# jspwiki   : ip=10.88.0.14 internal_port=8080
# postgres  : ip=10.88.0.15 internal_port=5432
# centosvnc : ip=10.88.0.16 external_port=5901


############################
# procedure d installation #
############################
./build_centos7_vnc.sh
./install_guacamole.sh

# access to guacamole
http://localhost:2001/guacamole/
guacadmin/guacadmin

-> change the guacadmin password
parametres/preferences

-> create a new connection
Nom:VNC
Protocole:VNC
Guacd hostname:10.88.0.12
Guacd port:4822
Encryption:None
Reseau hote:10.88.0.16
Reseau port:5901
Mot de passe:mycentosvnc

# access with vncviewer via ssh connection
# example : 
vncviewer -via centos@minis.home -QualityLevel 9 -NoJPEG -FullScreen localhost::5901

# etherpad
./install_etherpad.sh

# jspwiki
./install_jspwiki.sh

# nginx ssl test
./install_nginxssl.sh 2080 2443 TEST

# nginx ssl mise en prod : (va requeter les certificats)
./install_nginxssl.sh 80 443 PROD

