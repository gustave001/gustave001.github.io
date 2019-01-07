---
title: Kubernates(k8s)
tags: [k8s,Kubernates]
date: 2019-01-07 01:54:23
updated: 2019-01-07 01:54:23
categories: 好奇尚异
---
# 搭建k8s集群
## 主机名映射
```jshelllanguage
cat /etc/hosts
127.0.0.1	localhost
192.168.213.130   k8s-master
192.168.213.131   k8s-slave
```
主机名和IP加入到hostname
```jshelllanguage
cat /etc/hostname
```
## 在所有节点上安装kubeadm，这里使用阿里云的系统和kubernetes的源
```jshelllanguage
root@k8s-master:~# cat /etc/apt/sources.list
deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse

deb https://mirrors.aliyun.com/kubernetes/apt kubernetes-xenial main
```
## 更新源并安装kubeadm, kubectl, kubelet软件包;安装docker.io(非docker-ce)
```jshelllanguage
apt-get update -y && apt-get install -y kubelet kubeadm kubectl --allow-unauthenticated

apt-get install docker.io -y

```
## 使用kubeadmin初始化master节点，这里有两个坑！！
- 坑1、使用网络上常见的方式，那么如果没有用vpn翻墙，那么则会卡住，无法下载，幸好v1.13.0版本无需翻墙，指定版本即可
```jshelllanguage
kubeadm init \
--image-repository registry.aliyuncs.com/google_containers \
--kubernetes-version v1.13.0 \
--pod-network-cidr=10.244.0.0/16 \
--apiserver-advertise-address=192.168.213.130
```
- 坑2、需要禁用swap
修改/etc/fstab
```jshelllanguage
root@k8s-master:~# cat /etc/fstab 
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
/dev/mapper/ubuntugustave--vg-root /               ext4    errors=remount-ro 0       1
# /boot was on /dev/sda1 during installation
# UUID=340c3d0f-eb29-4512-83ca-ef6ba9d8577f /boot           ext2    defaults        0       2
# /dev/mapper/ubuntugustave--vg-swap_1 none            swap    sw              0       0
```
修改之后执行`swapoff -a`
如果还不行 `kubeadm reset`
## 大功告成
```jshelllanguage
root@k8s-master:~# kubeadm init --image-repository registry.aliyuncs.com/google_containers --kubernetes-version v1.13.0 --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.213.130
[init] Using Kubernetes version: v1.13.0
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'

[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Activating the kubelet service
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [k8s-master localhost] and IPs [192.168.213.130 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [k8s-master localhost] and IPs [192.168.213.130 127.0.0.1 ::1]
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [k8s-master kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.168.213.130]
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
[apiclient] All control plane components are healthy after 28.005554 seconds
[uploadconfig] storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config-1.13" in namespace kube-system with the configuration for the kubelets in the cluster
[patchnode] Uploading the CRI Socket information "/var/run/dockershim.sock" to the Node API object "k8s-master" as an annotation
[mark-control-plane] Marking the node k8s-master as control-plane by adding the label "node-role.kubernetes.io/master=''"
[mark-control-plane] Marking the node k8s-master as control-plane by adding the taints [node-role.kubernetes.io/master:NoSchedule]
[bootstrap-token] Using token: 3lnb74.tku3cdu5bagn0air
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstraptoken] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstraptoken] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstraptoken] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstraptoken] creating the "cluster-info" ConfigMap in the "kube-public" namespace
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes master has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of machines by running the following on each node
as root:

  kubeadm join 192.168.213.130:6443 --token 3lnb74.tku3cdu5bagn0air --discovery-token-ca-cert-hash sha256:2ba48ce20ebefcfb6d07ddf01141590eb81cad5de5c0406f08f41faab26a8696
```
- 按图索骥,按指示的方式配置k8s就行了,其中最后显示的kubeadm join语句包含了节点添加的token等等
```jshelllanguage
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
## 安装网络插件canal
- 执行如下两条命令即可
```jshelllanguage
kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/canal/rbac.yaml
 
clusterrole.rbac.authorization.k8s.io "calico" created
clusterrole.rbac.authorization.k8s.io "flannel" created
clusterrolebinding.rbac.authorization.k8s.io "canal-flannel" created
clusterrolebinding.rbac.authorization.k8s.io "canal-calico" created
 
 
kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/canal/canal.yaml
 
configmap "canal-config" created
daemonset.extensions "canal" created
customresourcedefinition.apiextensions.k8s.io "felixconfigurations.crd.projectcalico.org" created
customresourcedefinition.apiextensions.k8s.io "bgpconfigurations.crd.projectcalico.org" created
customresourcedefinition.apiextensions.k8s.io "ippools.crd.projectcalico.org" created
customresourcedefinition.apiextensions.k8s.io "clusterinformations.crd.projectcalico.org" created
customresourcedefinition.apiextensions.k8s.io "globalnetworkpolicies.crd.projectcalico.org" created
customresourcedefinition.apiextensions.k8s.io "networkpolicies.crd.projectcalico.org" created
serviceaccount "canal" created

```
- 执行如下命令，可以就可以查看canal的安装状态了
```jshelllanguage
root@k8s-master:~# kubectl get pod -n kube-system -o wide
NAME                                 READY   STATUS    RESTARTS   AGE   IP                NODE         NOMINATED NODE   READINESS GATES
canal-6f6kk                          3/3     Running   0          58m   192.168.213.130   k8s-master   <none>           <none>
canal-rgb57                          3/3     Running   0          50m   192.168.213.131   k8s-slave    <none>           <none>
coredns-78d4cf999f-hp7cv             1/1     Running   0          64m   10.244.0.3        k8s-master   <none>           <none>
coredns-78d4cf999f-p4r7w             1/1     Running   0          64m   10.244.0.2        k8s-master   <none>           <none>
etcd-k8s-master                      1/1     Running   0          69m   192.168.213.130   k8s-master   <none>           <none>
kube-apiserver-k8s-master            1/1     Running   0          68m   192.168.213.130   k8s-master   <none>           <none>
kube-controller-manager-k8s-master   1/1     Running   0          69m   192.168.213.130   k8s-master   <none>           <none>
kube-proxy-fknxh                     1/1     Running   0          50m   192.168.213.131   k8s-slave    <none>           <none>
kube-proxy-pvt8w                     1/1     Running   0          69m   192.168.213.130   k8s-master   <none>           <none>
kube-scheduler-k8s-master            1/1     Running   0          69m   192.168.213.130   k8s-master   <none>           <none>
```
# slave节点在集群中的操作
## 增加新的Node节点到你的集群的命令如下：
```jshelllanguage
  kubeadm join 192.168.213.130:6443 --token 3lnb74.tku3cdu5bagn0air --discovery-token-ca-cert-hash sha256:2ba48ce20ebefcfb6d07ddf01141590eb81cad5de5c0406f08f41faab26a8696
```
- token，一般token两天就过期了，如果过期了你需要重新创建（查看token命令是kubeadm token list，创建token命令是kubeadm token create)，如下：
```jshelllanguage
root@k8s-master:~# kubeadm token list
TOKEN                     TTL       EXPIRES                     USAGES                   DESCRIPTION                                                EXTRA GROUPS
3lnb74.tku3cdu5bagn0air   22h       2019-01-08T14:59:55+08:00   authentication,signing   The default bootstrap token generated by 'kubeadm init'.   system:bootstrappers:kubeadm:default-node-token
```
- --discovery-token-ca-cert-hash，通过如下命令就可以得到
```jshelllanguage
root@k8s-master:~# openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
2ba48ce20ebefcfb6d07ddf01141590eb81cad5de5c0406f08f41faab26a8696
```
## 删除slave节点
```jshelllanguage
kubectl drain <node name> --delete-local-data --force --ignore-daemonsets
kubectl delete node <node name>
```