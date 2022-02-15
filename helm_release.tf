provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
      command     = "aws"
    }
  }
}

resource "null_resource" "Deploy-helm-charts" {
 provisioner "local-exec" {
command = <<-EOT
      chmod u+x helm_charts_deploy.sh
      ./helm_charts_deploy.sh
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}

