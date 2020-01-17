# nginx     : port 2000
# guacamole : port 2001
# vncserver : port 2002
# etherpad  : port 2003
# jspwiki   : port 2004


# procedure
./build_centos7_vnc.sh
./install_guacpod.sh or ./uninstall_guacpod.sh

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
./install_etherpad.sh or ./uninstall_etherpad.sh

# jspwiki
./install_jspwiki.sh
