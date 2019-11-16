provider "google" {
  credentials = "${file(".json")}"
  project     = "${var.Google_Project}"
  region      = "${var.Region}"
}

resource "google_compute_network" "vpc" {
 name                    = "${var.vpc_name}"
 auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
 name          = "${var.vpc_name}"
 private_ip_google_access = true
 ip_cidr_range = "${var.subnet_cidr}"
 network       = "${var.vpc_name}"
 depends_on    = ["google_compute_network.vpc"]
 region      = "${var.Region}"
}

resource "google_compute_firewall" "firewall" {
  name    = "${var.vpc_name}-allow-ssh"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "http" {
  name    = "${var.vpc_name}-allow-http"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}


resource "google_compute_firewall" "https" {
  name    = "${var.vpc_name}-allow-https"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "tomcat" {
  name    = "${var.vpc_name}-allow-tomcat"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  source_ranges = ["${var.local_ipaddress}"]
}

resource "google_compute_firewall" "vnc" {
  name    = "${var.vpc_name}-allow-vnc"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["5901"]
  }
  source_ranges = ["${var.local_ipaddress}"]
}

resource "google_compute_instance" "default" {
  name         = "jenkins"
  machine_type = "n1-standard"
  zone         = "eu-west2-c"

  tags = ["allow-ssh"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  scratch_disk {
    interface = "SCSI"
  }
}
