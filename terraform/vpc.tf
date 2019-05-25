## VPC
resource "google_compute_network" "vpc" {
  name                    = "vpc-vuls"
  auto_create_subnetworks = false
}

## Subnetwork
resource "google_compute_subnetwork" "gke_cluster" {
  name          = "gke-cluster"
  ip_cidr_range = "10.10.0.0/20"
  region        = "asia-northeast2"
  network       = "${google_compute_network.vpc.self_link}"
}

## Router
resource "google_compute_router" "router" {
  name    = "router-vuls"
  region  = "${google_compute_subnetwork.gke_cluster.region}"
  network = "${google_compute_network.vpc.self_link}"

  bgp {
    asn = 64514
  }
}

## External Address
resource "google_compute_address" "address" {
  name   = "nat-external-address"
  region = "asia-northeast2"
}

## Router NAT
resource "google_compute_router_nat" "nat" {
  name                               = "nat-vuls"
  router                             = "${google_compute_router.router.name}"
  region                             = "asia-northeast2"
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = ["${google_compute_address.address.self_link}"]
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = "${google_compute_subnetwork.gke_cluster.self_link}"
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
