#!/usr/bin/env bash
# Get on the bastion host
gcloud compute ssh gg-controller-0
# Get a parallel shell controller on the bastion host
sudo apt update
sudo apt -y install pdsh
# Make lists of the nodes to be used by pdsh
gcloud compute instances list --filter="tags.items=k8sgcp AND tags.items=controller" --format="csv(name)[no-heading]" > controller-nodes.txt
gcloud compute instances list --filter="tags.items=k8sgcp AND tags.items=worker" --format="csv(name)[no-heading]" > worker-nodes.txt
cat controller-nodes.txt worker-nodes.txt >  all-nodes.txt
# The loop below has the effect of placing the host keys in ~/.ssh 
for i in `cat all-nodes.txt`; do echo $i; ssh -o StrictHostKeyChecking=no $i pwd; done
# Now we will use pdsh to install Docker, kubeadm, kubelet and kubectl
WCOLL=all-nodes.txt pdsh -R ssh 'sudo apt-get update && sudo apt-get install -y apt-transport-https curl'
WCOLL=all-nodes.txt pdsh -R ssh 'curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -'
WCOLL=all-nodes.txt pdsh -R ssh 'cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF'
WCOLL=all-nodes.txt pdsh -R ssh 'sudo apt update && sudo apt install -y docker.io kubelet kubeadm kubectl && sudo apt-mark hold kubelet kubeadm kubectl'
