terraform {
  backend "remote" {
    organization = "glitchycat"

    workspaces {
      name = "rose-court-infra-tf"
    }

  }
}

#need to update everything in the backend 
