provider "google" {
  credentials = "${file(".json")}"
  project     = "${var.project_name}"
}

#VPC

resource "google_compute_network" "vpc" {
 name                    = "${var.vpc_name}"
 auto_create_subnetworks = "false"
 routing_mode = "${var.routing_mode["Regional"]}"
}

# Create GCP Subnet 

resource "google_compute_subnetwork" "subnet" {
 name          = "${var.subnet_name}"
 region      = "${var.region["London"]}"
 ip_cidr_range = "${var.cidrs["London"]}"
 network       = google_compute_network.vpc.self_link
 private_ip_google_access = true
}

# GCP Router for NAT Instance

resource "google_compute_router" "router" {
  name    = "${var.router_name}"
  network = google_compute_network.vpc.self_link
  region  = google_compute_subnetwork.subnet.region
}

# GCP NAT for Private Hosts

resource "google_compute_router_nat" "nat" {
  name                               = "${var.nat_name}"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "${var.nat_allocation["Auto"]}"
  source_subnetwork_ip_ranges_to_nat = "${var.source_subnetwork["all_ip_ranges"]}"

  log_config {
    enable = true
    filter = "${var.log_config_error["errors"]}"
  }
}

#Firewall Rules

resource "google_compute_firewall" "firewall" {
  name    = "${var.vpc_name}-allow-ssh"
  network = "${google_compute_network.vpc.name}"
  source_tags = ["bastion_host"]
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["${var.local_cidrs["IE_Office"]}", "${var.local_cidrs["UK_Office"]}"]
}
