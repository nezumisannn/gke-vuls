## GKE cluster
resource "google_container_cluster" "primary" {
  name        = "vuls-cluster"
  location    = "asia-northeast2-a"
  description = "cluster for vuls"

  remove_default_node_pool = true
  initial_node_count       = 1

  logging_service    = "logging.googleapis.com"
  monitoring_service = "monitoring.googleapis.com"

  network    = "${google_compute_network.vpc.self_link}"
  subnetwork = "${google_compute_subnetwork.gke_cluster.self_link}"

  ip_allocation_policy {
    use_ip_aliases           = true
    cluster_ipv4_cidr_block  = "10.96.0.0/11"
    services_ipv4_cidr_block = "10.94.0.0/18"
  }

  private_cluster_config {
    enable_private_nodes   = true
    master_ipv4_cidr_block = "172.16.0.0/28"
  }

  master_authorized_networks_config {
    cidr_blocks = [
      {
        cidr_block   = "0.0.0.0/0"
        display_name = "ALL"
      },
    ]
  }

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

## Scanner node pool
resource "google_container_node_pool" "scanner" {
  name       = "scanner"
  location   = "asia-northeast2-a"
  cluster    = "${google_container_cluster.primary.name}"
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "n1-standard-2"
    disk_type    = "pd-standard"
    disk_size_gb = "50"

    metadata {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
