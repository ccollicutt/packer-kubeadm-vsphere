# Packer Kubeadm Vsphere

This is packer configuration to build a vm template to run kubeadm in a vsphere environment. You can use packer to build a template and then use that template to create kubernetetes nodes in vsphere. All it really does is build the template, install docker and kubeadm.

This is mostly based on [Myles Gray's work](https://blah.cloud/kubernetes/creating-an-ubuntu-18-04-lts-cloud-image-for-cloning-on-vmware/).

I also borrowed most of the packer config from a github repository that I can no longer find.

## Build Template in vSphere

Use the sample variables file.

*NOTE: The ubuntu user and password are hardcoded into the preseed file so don't change those unless you want to also change the preseed file.*

```
cp variables.json.sample variables.json
```

Edit that file and add vcenter information and a public key.

Now build.

```
packer build --force -var-file variables.json ubuntu-18.json
```

Once that completes there should be a new template that can be used to build k8s nodes.

## Built an OS Customization Spec

Currently it seems we need to run some powershell to get a customized vm spec. We are using this instead of something like cloud-init.

*NOTE: This requires powershell installed.*

```
$ pwsh
> Connect-VIServer <vcenter> -User <administrator@vsphere.local> -Password <Admin!23>
> New-OSCustomizationSpec -Name Ubuntu -OSType Linux -DnsServer <dns server> -DnsSuffix <dns suffix> -Domain <dns suffix> -NamingScheme vm
```

## Deploy Nodes From Template

Now we can create vms from that template and spec.

*NOTE: This requires govc is installed and configured.*

```
govc vm.clone -vm test-kubeadm-template -customization=Ubuntu k8s-controller
govc vm.clone -vm test-kubeadm-template -customization=Ubuntu k8s-node-1
govc vm.clone -vm test-kubeadm-template -customization=Ubuntu k8s-node-2
```