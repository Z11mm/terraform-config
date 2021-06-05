# Specify cloud provider
provider "google" {
    credentials = "${file("my-startup-project-281916-7c26344b85ac.json")}"
    project = "my-startup-project-281916"
    region = "us-central1"
}

# Specify vm instance
resource "google_compute_instance" "default" {
  name = "test-instance-1"
  machine_type = "e2-medium"
  zone = "us-central1-a"

#  Apply the firewall rule to allow external IPs to access this instance
  tags = [ "http-server" ]

  network_interface {
    network = "default"

    access_config {
    #   Include this block to give the VM a public IP address
    }
  }

  boot_disk {
    initialize_params {
        image = "debian-10-buster-v20210512"
        type = "pd-balanced"
        size = 10
    }
  }

# Run web server on instance
  metadata_startup_script = "sudo apt-get update && sudo apt-get install apache2 -y && echo '<!doctype html><html><body><h1>Hello from Terraform on Google Cloud!</h1></body></html>' | sudo tee /var/www/html/index.html"
}

# Allow incoming web traffic to instance
resource "google_compute_firewall" "default" {
  name = "default-allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["8080"]
  }

  source_ranges = [ "0.0.0.0/0" ]
  target_tags = [ "http-server" ]

  direction = "INGRESS"
}

output "public ip" {
  value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}