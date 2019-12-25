#!/bin/bash -eu

SSH_USER=${SSH_USERNAME:-ubuntu}

echo "==> enable cloud-init services..."
# systemctl enable cloud-init-local.service
# systemctl enable cloud-init.service
# systemctl enable cloud-config.service
# systemctl enable cloud-final.service

echo "==> Cleaning up tmp..."
rm -rf /tmp/*

# Cleanup apt cache
apt-get -y autoremove --purge
apt-get -y clean

echo "==> Installed packages"
dpkg --get-selections | grep -v deinstall

echo "==> Removing bash history..."
# Remove Bash history
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/${SSH_USER}/.bash_history

echo "==> Clearing log files..."
find /var/log -type f -exec truncate --size=0 {} \;

echo "===> dding drive..."
# NOTE: This takes a long time on slow disk...
# Zero out the free space to save space in the final image
#dd if=/dev/zero of=/EMPTY bs=1M || echo "dd exit code $? is suppressed"
#rm -f /EMPTY
#sync

echo "==> Disk usage after cleanup"
df -h

