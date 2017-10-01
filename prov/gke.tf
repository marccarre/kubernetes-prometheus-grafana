variable "project" {
  description = "Name of your project in Google Cloud Platform."
}

variable "cluster" {
  description = "Name of your cluster."
}

variable "region" {
  description = "Google Cloud Platform's selected region. See also: $ gcloud compute regions list"
  default     = "us-central1"
}

variable "zone" {
  description = "Google Cloud Platform's selected zone. See also: $ gcloud compute zones list"
  default     = "us-central1-a"
}

variable "machine_type" {
  description = "Google Cloud Platform's selected machine type. See also: $ gcloud compute machine-types list"
  default     = "n1-standard-1"
}

variable "initial_node_count" {
  description = "Initial number of Kubernetes nodes."
  default     = 3
}

variable "username" {
  description = "Username to access the Kubernetes master(s)."
  default     = "admin"
}

variable "password" {
  description = "Password to access the Kubernetes master(s)."
  default     = "admin"
}

variable "node_version" {
  description = "Kubernetes version used on the master and worker nodes."
  default     = "1.7.6-gke.1"
}

provider "google" {
  region = "${var.region}"

  project = "${var.project}"
}

resource "google_container_cluster" "default" {
  name         = "${var.cluster}"
  zone         = "${var.zone}"
  node_version = "${var.node_version}"

  node_pool = [{
    name_prefix        = "${var.cluster}"
    initial_node_count = "${var.initial_node_count}"

    node_config {
      machine_type = "${var.machine_type}"

      oauth_scopes = [
        "https://www.googleapis.com/auth/compute",
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
      ]
    }
  }]

  master_auth {
    username = "${var.username}"
    password = "${var.password}"
  }
}
