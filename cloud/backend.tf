terraform {
  required_version = ">= 1.0.0"
  backend "remote" {
    organization = "storyai"

    workspaces {
      name = "story-ai-cloud"
    }
  }
}