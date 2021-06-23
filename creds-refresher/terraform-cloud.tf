terraform {
  backend "remote" {
    organization = "storyai"

    workspaces {
      name = "story-ai-global-creds-refresher"
    }
  }
}
