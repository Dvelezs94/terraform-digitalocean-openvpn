terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }
    remote = {
      source  = "tenstad/remote"
      version = "~> 0.0.24"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.2"
    }
  }
}