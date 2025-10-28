target "docker-metadata-action" {}

variable "APP" {
  default = "external-secrets"
}

variable "VERSION" {
  // renovate: datasource=github-tags depName=external-secrets/external-secrets
  default = "v0.9.20"
}

variable "SOURCE" {
  default = "https://github.com/external-secrets/external-secrets"
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
  args = {
    VERSION = "${VERSION}"
  }
  labels = {
    "org.opencontainers.image.source" = "${SOURCE}"
  }
}

target "image-local" {
  inherits = ["image"]
  output = ["type=docker"]
  tags = ["${APP}:${VERSION}"]
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}
