# nginx     : port 2000
# guacamole : port 2001
# vncserver : port 2002
# etherpad  : port 2003
# jspwiki   : port 2004


############################
# procedure d installation #
############################
./install_pod.sh
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
Guacd hostname:localhost
Guacd port:4822
Encryption:None
Reseau hote:localhost
Reseau port:5901


# access with vncviewer via ssh connection
vncviewer -via centos@<hostname> -QualityLevel 9 -NoJPEG -FullScreen localhost::2002

# etherpad
./install_etherpad.sh

# jspwiki
./install_jspwiki.sh

# nginx
./install_nginx.sh
