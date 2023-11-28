echo 'install master kubernetes'
sudo yum -y update
hostnamectl set-hostname k8s-master
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
cat <<EOF >> /etc/hosts
10.5.120.143 k8s-master
10.5.120.124 k8s-node
EOF
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF
yum install kubeadm-1.20.9-0 kubelet-1.20.9-0 kubectl-1.20.9-0 docker -y --disableexcludes=kubernetes
systemctl start docker && systemctl enable docker
systemctl start kubelet && systemctl enable kubelet
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
swapoff -a
sudo sed -i '/swap/d' /etc/fstab
kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=10.5.120.143
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
curl -o  calico.yaml https://docs.projectcalico.org/v3.8/manifests/calico.yaml
sed -i -r "s/10.5.0.0/10.244.0.0/g" calico.yaml
kubectl apply -f calico.yaml
kubectl get pods --all-namespaces