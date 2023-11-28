# Project Name: hamdi458 Portfolio - ISI Cloud DevOps
# Description
This project contains the setup for a personal portfolio website using a Static Site Generator, Docker, and Kubernetes for deployment. 

# Requirements
Vagrant <br/>
Kubernetes <br/>
Docker  <br/>
# Setup Instructions
Creating a Kubernetes-only Master Node <br/>
Spin up a VM using Vagrant with the provided script kubernetes-master-setup.sh. <br/>
# Commands to set up Kubernetes master node
$ echo 'install master kubernetes' <br/>
$ sudo yum -y update <br/>
$ hostnamectl set-hostname k8s-master <br/>
 setenforce 0 <br/>
 sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config <br/>
$ cat <<EOF >> /etc/hosts <br/>
 10.5.120.143 k8s-master <br/>
 10.5.120.124 k8s-node <br/>
EOF <br/>
$ cat <<EOF > /etc/yum.repos.d/kubernetes.repo <br/>
[kubernetes] <br/>
name=Kubernetes <br/>
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch <br/>
enabled=1 <br/> 
gpgcheck=1 <br/>
repo_gpgcheck=0 <br/> 
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg <br/>
exclude=kubelet kubeadm kubectl <br/>
EOF <br/>
$ yum install kubeadm-1.20.9-0 kubelet-1.20.9-0 kubectl-1.20.9-0 docker -y --disableexcludes=kubernetes <br/>
$ systemctl start docker && systemctl enable docker <br/>
$ systemctl start kubelet && systemctl enable kubelet <br/>
$ cat <<EOF >  /etc/sysctl.d/k8s.conf <br/>
 net.bridge.bridge-nf-call-ip6tables = 1 <br/>
 net.bridge.bridge-nf-call-iptables = 1 <br/>
EOF <br/>
$ sysctl --system <br/>
$ swapoff -a <br/>
$ sudo sed -i '/swap/d' /etc/fstab <br/>
$ kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=10.5.120.143 <br/>
$ mkdir -p $HOME/.kube <br/>
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config <br/>
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config <br/>
$ curl -o  calico.yaml https://docs.projectcalico.org/v3.8/manifests/calico.yaml <br/>
$ sed -i -r "s/10.5.0.0/10.244.0.0/g" calico.yaml <br/>
$ kubectl apply -f calico.yaml <br/>
$ kubectl get pods --all-namespaces <br/>
...
Follow the script to configure the master node and initialize Kubernetes. <br/>
Ensure the necessary ports and configurations and make sure to make the address ip public are in place for Kubernetes. <br/>
# Building Docker Image for Portfolio <br/>
$ Clone the project repository: <br/>
$ git clone https://github.com/hamdi458/hamdi458-portfolio-isi-cloud-devops.git <br/>
$ cd hamdi458-portfolio-isi-cloud-devops/portfolio_image/ <br/>
# Build the Docker image for the portfolio: <br/>
$ docker build -t sldbahta/portfolio . <br/>
![alt text](https://github.com/hamdi458/hamdi458-portfolio-isi-cloud-devops/blob/main/portfolio_image/Capture.PNG) <br/>
# Dockerhub Integration <br/>
# 1.Log in to Dockerhub: <br/>
$ docker login <br/>
# 2.Push the Docker image to Dockerhub: <br/>
$ docker push sldbahta/portfolio <br/>
![alt text](https://github.com/hamdi458/hamdi458-portfolio-isi-cloud-devops/blob/main/portfolio_image/Capture2.PNG) <br/>
![alt text](https://github.com/hamdi458/hamdi458-portfolio-isi-cloud-devops/blob/main/portfolio_image/Capture3.PNG) <br/>
# Deploying on Kubernetes <br/>
# Create Kubernetes components for deployment: <br/>
$ kubectl create -f portfolio.yml <br/>
![alt text](https://github.com/hamdi458/hamdi458-portfolio-isi-cloud-devops/blob/main/portfolio_image/Capture4.PNG)
# Access via Browser: Open a web browser and enter the following in the address bar:
http://NODE_IP:NodePort <br/> <br/> <br/>
![alt text](https://github.com/hamdi458/hamdi458-portfolio-isi-cloud-devops/blob/main/portfolio_image/capture5.PNG)
![alt text](https://github.com/hamdi458/hamdi458-portfolio-isi-cloud-devops/blob/main/portfolio_image/Capture6.PNG)
![alt text](https://github.com/hamdi458/hamdi458-portfolio-isi-cloud-devops/blob/main/portfolio_image/Capture7.PNG)
![alt text](https://github.com/hamdi458/hamdi458-portfolio-isi-cloud-devops/blob/main/portfolio_image/Capture8.PNG)
![alt text](https://github.com/hamdi458/hamdi458-portfolio-isi-cloud-devops/blob/main/portfolio_image/Capture9.PNG)


