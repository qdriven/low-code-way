#!/usr/bin/env bash
#
# The interface of MDNotifyCmd commands is undocumented. If a single argument is provided to the MDNotifyCmd directive,
# it calls the provided command with the domain as the only argument.
#
# https://github.com/icing/mod_md/blob/master/test/test_0900_notify.py

# https://www.openssl.org/docs/manmaster/man1/openssl-pkcs12.html
# https://www.openssl.org/docs/manmaster/man1/openssl-passphrase-options.html
openssl pkcs12 -password file:/opt/pkcs-password -in /etc/apache2/md/domains/$1/pubcert.pem -out /etc/apache2/md/domains/$1/pkcs.p12 -export -inkey /etc/apache2/md/domains/$1/privkey.pem -name $1

# https://docs.oracle.com/javase/8/docs/technotes/tools/unix/keytool.html#keytool_option_importkeystore
keytool -importkeystore -noprompt -srckeystore /etc/apache2/md/domains/$1/pkcs.p12 -srcstorepass:file /opt/pkcs-password -srcstoretype PKCS12 -srcalias $1 -destkeystore /etc/elasticsearch/keystore.jks -deststorepass:file /opt/pkcs-password
