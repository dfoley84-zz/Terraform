provider "google" {
  credentials = "${file("credentials.json")}"
  project     = "${var.Google_Project}"
  region      = "${var.Region}"
}

resource "google_compute_network" "Project_Network" {
  name = "Linux Project"
  project = "${var.project}"
  
}





