terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.30.0"
    }
  }
  backend "gcs" {
    bucket = "bomky-gcp"
    prefix = "nlb"
  }
}

provider "google" {
  credentials = file("../creds/serviceaccount.json")
  project     = var.project_id # REPLACE WITH YOUR PROJECT ID
  region      = var.region
}