# Specify cloud provider
provider "google" {
    project = "my-startup-project-281916"
    region = "us-central1"
}

# Specify vm instance
resource "google_compute_instance" "default" {
  name = "test_instance_1"
  machine_type = "e2-medium"
  zone = "us-central1-a"

  network_interface {
    network = "default"
  }

  boot_disk {
    initialize_params {
        image = "debian-10-buster-v20210512"
        type = "pd-balanced"
        size = "10GB"
    }
  }
}