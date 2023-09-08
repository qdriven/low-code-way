#!/bin/bash

cat > /etc/ssh/sshd_config << 'EOF'
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key
SyslogFacility AUTHPRIV
PermitRootLogin no
PasswordAuthentication yes
PermitEmptyPasswords no
ChallengeResponseAuthentication no
UsePAM yes
UseDNS no
X11Forwarding no
AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE
AcceptEnv XMODIFIERS
AllowGroups sftp
Subsystem sftp internal-sftp -u 0007
EOF

for user in `cat /tmp/sftp-users`
do
    username="${user%%:*}"
    chroot_directory="${SFTP_HOME}/data/${user##*:}"

    echo "Match User ${username}" >> /etc/ssh/sshd_config
    echo "ChrootDirectory ${chroot_directory}" >> /etc/ssh/sshd_config

    useradd -g sftp -d /var/empty/${username} -s /sbin/nologin ${username} || echo
    mkdir -p ${chroot_directory}/bucket

    chown root:sftp ${chroot_directory}
    chmod 755 ${chroot_directory}
    chown ${username}:sftp ${chroot_directory}/bucket -R
    chmod 775 ${chroot_directory}/bucket
done

cat /tmp/sftp-users-passwd | chpasswd
chown root:sftp ${SFTP_HOME}/data

exec /usr/sbin/sshd -D
