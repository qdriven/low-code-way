#!/bin/bash

cat > ${OPENSSH_HOME}/etc/sshd_config << 'EOF'
PermitRootLogin no
PermitEmptyPasswords no
AllowGroups sftp
Subsystem sftp internal-sftp
EOF

chown root:sftp ${SFTP_HOME}/data

for user in `cat /tmp/users`
do
    chroot_directory="${SFTP_HOME}/data/${user%%:*}"
    username="${chroot_directory##*/}"
    password="${user#*:}"

    echo "Match User ${username}" >> ${OPENSSH_HOME}/etc/sshd_config
    echo "ChrootDirectory ${chroot_directory}" >> ${OPENSSH_HOME}/etc/sshd_config
    echo "ForceCommand internal-sftp" >> ${OPENSSH_HOME}/etc/sshd_config

    useradd -g sftp -s /sbin/nologin ${username} || echo
    echo -n "${password}" | passwd --stdin ${username}
    mkdir -p ${chroot_directory}/bucket

    chown root:sftp ${chroot_directory}
    chmod 755 ${chroot_directory}
    chown ${username}:sftp ${chroot_directory}/bucket -R
    chmod 775 ${chroot_directory}/bucket
done

exec ${OPENSSH_HOME}/sbin/sshd -D
