terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.49.0"
    }
  }
}

provider "google" {
  credentials = ".json"
  project = ""
  region = "us-central1"
  zone = "us-central1-c"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "e2-micro"




  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
      labels = {
        my_label = "value"
      }
    }
  }



  network_interface {
    network = "default"
    access_config {}
  }
}



