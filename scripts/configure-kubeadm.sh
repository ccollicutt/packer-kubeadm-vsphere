#!/bin/bash

tee /etc/kubernetes/vsphere.conf >/dev/null <<EOF
[Global]
user = "$VCENTER_USER"
password = "$VCENTER_PASSWORD"
port = "443"
insecure-flag = "1"

[VirtualCenter "$VCENTER_IP"]
datacenters = "$VCENTER_DATACENTER"

[Workspace]
server = "$VCENTER_IP"
datacenter = "$VCENTER_DATACENTER"
default-datastore = "$VCENTER_DATASTORE"
resourcepool-path = "$VCENTER_CLUSTER/Resources"
folder = "$VCENTER_FOLDER"

[Disk]
scsicontrollertype = pvscsi

[Network]
public-network = "$VCENTER_NETWORK"
EOF

tee /etc/kubernetes/kubeadminitmaster.yaml >/dev/null <<EOF
apiVersion: kubeadm.k8s.io/v1beta1
kind: InitConfiguration
bootstrapTokens:
       - groups:
         - system:bootstrappers:kubeadm:default-node-token
         token: y7yaev.9dvwxx6ny4ef8vlq
         ttl: 0s
         usages:
         - signing
         - authentication
nodeRegistration:
  kubeletExtraArgs:
    cloud-provider: "vsphere"
    cloud-config: "/etc/kubernetes/vsphere.conf"
---
apiVersion: kubeadm.k8s.io/v1beta1
kind: ClusterConfiguration
kubernetesVersion: v1.17.0
apiServer:
  extraArgs:
    cloud-provider: "vsphere"
    cloud-config: "/etc/kubernetes/vsphere.conf"
  extraVolumes:
  - name: cloud
    hostPath: "/etc/kubernetes/vsphere.conf"
    mountPath: "/etc/kubernetes/vsphere.conf"
controllerManager:
  extraArgs:
    cloud-provider: "vsphere"
    cloud-config: "/etc/kubernetes/vsphere.conf"
  extraVolumes:
  - name: cloud
    hostPath: "/etc/kubernetes/vsphere.conf"
    mountPath: "/etc/kubernetes/vsphere.conf"
networking:
  podSubnet: "10.244.0.0/16"
EOF

tee /etc/kubernetes/kubeadminitworker.yaml >/dev/null <<EOF
apiVersion: kubeadm.k8s.io/v1alpha3
kind: JoinConfiguration
discoveryFile: discovery.yaml
token: y7yaev.9dvwxx6ny4ef8vlq
nodeRegistration:
  kubeletExtraArgs:
    cloud-provider: vsphere
EOF

tee /etc/kubernetes/csi-vsphere.conf >/dev/null <<EOF
[Global]
cluster-id = "$VCENTER_DATACENTER-$VCENTER_CLUSTER"
[VirtualCenter "$VCENTER_IP"]
insecure-flag = "true"
user = "$VCENTER_USER"
password = $VCENTER_PASSWORD
port = "443"
datacenters = "$VCENTER_DATACENTER"
EOF


