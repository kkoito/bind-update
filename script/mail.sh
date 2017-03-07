#!/bin/bash
. ~/bind-update/script/var.list 2> /dev/null
 
NEW_PKG1=`rpm -qa|grep bind|sort|tail -1 |head -1`
NEW_PKG2=`rpm -qa|grep bind|sort|tail -2 |head -1`
NEW_PKG3=`rpm -qa|grep bind|sort|tail -3 |head -1`

CONNECT_HOST='localhost'; export CONNECT_HOST
(echo "ehlo localhost.localdomain"; sleep 1
echo "mail from: <kkoito@idcf.jp>"; sleep 1
echo "rcpt to: <kkoito@idcf.jp>"; sleep 1
echo "data"; sleep 1
echo "subject:BIND New PKG Released"; sleep 1
echo "from:kkoito@idcf.jp"
echo "to:kkoito@idcf.jp"
echo "Please Check Server[BIND-test-ansible]"
echo "New BIND PKG LIST:"
echo "${NEW_PKG1}"
echo "${NEW_PKG2}"
echo "${NEW_PKG3}"
echo ""
echo " Please check logs in  ${NEWPKG_DIR}/`date +%Y%m%d`"
echo "."; sleep 1
echo "quit") |/usr/bin/telnet ${CONNECT_HOST} 25

exit 0
