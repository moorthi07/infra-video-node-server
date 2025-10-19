variable "namespace" {
  default = "demo"
}

variable "kubeconfig" {
  description = "Path to your kubeconfig file"
  default     = "~/.kube/config"
}
