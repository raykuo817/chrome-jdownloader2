#!/bin/bash
set -e

# JD2 enviroement for supervisor process contrl system
case ${JDOWNLOADER2_AUTO_START:-true} in
    true|yes|y|1)
	JDOWNLOADER2_AUTO_START=true ;;
    *)
	JDOWNLOADER2_AUTO_START=false ;;
esac
case ${JDOWNLOADER2_AUTO_RESTART:-true} in
    true|yes|y|1)
	JDOWNLOADER2_AUTO_RESTART=true ;;
    *)
	JDOWNLOADER2_AUTO_RESTART=false ;;
esac
export JDOWNLOADER2_AUTO_START
export JDOWNLOADER2_AUTO_RESTART


# x11vnc password
mkdir -p /etc/x11vnc
if [ ${VNC_PW:-""} == "" ]; then
    USEPWD_PARAM=
else
    touch /etc/x11vnc/passwd
    x11vnc -storepasswd $VNC_PW /etc/x11vnc/passwd
    USEPWD_PARAM='-rfbauth /etc/x11vnc/passwd'
fi
export USEPWD_PARAM

#
exec supervisord -c /etc/supervisor/supervisord.conf


