#!/bin/bash

OPENSSL=openssl

echo -e "GET / HTTP/1.0\r\nHost:www.test.com\r\nConnection:close\r\n\r\n" | ${OPENSSL} s_client -ign_eof -connect 192.168.100.20:55555 -cert rsa-user.pem -key rsa-user.key -CAfile rootca.pem -msg -debug

#echo -e "GET /1mb HTTP/1.0\r\nHost:www.test.com\r\nConnection:close\r\n\r\n" | ${OPENSSL} s_client -ign_eof -connect 192.168.100.20:55555 -cert rsa-user.pem -key rsa-user.key -CAfile rootca.pem -no_ticket

