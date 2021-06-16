terraform {
  backend "remote" {
    organization = "storyai"

    workspaces {
      prefix = "storytime-"
    }
  }
}
