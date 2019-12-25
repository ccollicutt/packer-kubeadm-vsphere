#!/bin/bash

# https://cloud-provider-vsphere.sigs.k8s.io/tutorials/kubernetes-on-vsphere-with-kubeadm.html

# install docker

apt install ca-certificates software-properties-common apt-transport-https curl -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

apt update

# Orig version
#apt install docker-ce=18.06.0~ce~3-0~ubuntu -y

# 1.17 can do 19.03...
apt install docker-ce=5:19.03.4~3-0~ubuntu-$(lsb_release -cs) -y

tee /etc/docker/daemon.json >/dev/null <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

systemctl daemon-reload

systemctl restart docker

systemctl status docker

docker info | egrep "Server Version|Cgroup Driver"

# add ubuntu user to docker group 
#usermod -aG docker ubuntu
