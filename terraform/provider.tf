provider "google" {
  credentials = "${file("Your credential file path")}"
  project     = "Your project id"
  region      = "Your region"
}
