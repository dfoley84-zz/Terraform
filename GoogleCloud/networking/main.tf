provider "google" {
  credentials = "${file(".json")}"
  project     = "${var.project_name}"
}

# --- Create GCP Networking Stack ---

# Create GCP VPC

resource "google_compute_network" "vpc" {
 name                    = "${var.vpc_name}"
 auto_create_subnetworks = "false"
}

# Create GCP Subnet 

resource "google_compute_subnetwork" "subnet" {
 name          = "${var.subnet_name}"
 private_ip_google_access = true
 ip_cidr_range = "${var.london_cidr}"
 network       = google_compute_network.vpc.self_link
 region      = "${var.region_london}"
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
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_firewall" "bastion_host" {
  name    = "allow-ssh"
  network = google_compute_network.vpc.name
  source_tags = ["bastion"]
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = "22"
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "private_host" {
  name    = "allow-ssh"
  network = google_compute_network.vpc.name
  source_tags = ["private_hosts"]
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = "22"
  }
 source_ranges = ["172.27.1.12/32"]
}


