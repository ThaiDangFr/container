# procedure
./build_centos7_vnc.sh
./install_guacpod.sh or ./uninstall_guacpod.sh

# access to guacamole
http://localhost:1000/guacamole/
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
vncviewer -via centos@<hostname> -QualityLevel 9 -NoJPEG -FullScreen localhost::1001

