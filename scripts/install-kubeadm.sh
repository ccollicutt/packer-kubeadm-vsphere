#!/bin/bash

# install kubeadm

apt-get update &&  apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg |  apt-key add -
cat <<EOF |  tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet=1.17.0-00 kubeadm=1.17.0-00 kubectl=1.17.0-00
apt-mark hold kubelet kubeadm kubectl

# For flannel - https://cloud-provider-vsphere.sigs.k8s.io/tutorials/kubernetes-on-vsphere-with-kubeadm.html
sysctl net.bridge.bridge-nf-call-iptables=1