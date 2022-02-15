#!/bin/bash

# update kubeconfig
cd ../terraform-provision-eks-cluster; aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)



# deploy GitLab runner
cd ../terraform-helm-deploy
helm repo add gitlab https://charts.gitlab.io
helm install --namespace dwp-cc-dev gitlab-runner -f values.yaml gitlab/gitlab-runner

# deploy cert manager
helm repo add jetstack https://charts.jetstack.io
helm install cert-manager jetstack/cert-manager --namespace dwp-cc-dev --version v1.7.1 --set installCRDs=true


# deploy apache web server
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install apache2 bitnami/apache --namespace dwp-cc-dev --set replicaCount=2

#  deploy dashboard and metric server
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm upgrade --install metrics-server metrics-server/metrics-server --namespace kube-system
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
kubectl apply -f recommended.yaml
