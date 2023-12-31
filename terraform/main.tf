provider "google" {
    project = var.project_id
    region = var.region_name
}

terraform {
  backend "gcs" {
    bucket = "tf_statebucket_4_crwg_repo"
    prefix = "tf_statebucket_4_crwg_repo"
  }
}

#resource "google_project_iam_binding" "sa-deployer-run-admin" {
#  project = var.project_id
#  role    = "roles/iam.serviceaccounts.actAs"
#  members = [
#    "github-actions-latest@plated-hash-405319.iam.gserviceaccount.com",
#  ]
#}

resource "google_cloud_run_service" "my-second-cloudrun-service" {
    name = var.service_name
    location = var.service_location
    template {
        spec {
          containers {
            image="us-east1-docker.pkg.dev/plated-hash-405319/githubaction-testing-cloudrun1/githubactioncodeimage1"
          }
          service_account_name = "github-actions-latest@plated-hash-405319.iam.gserviceaccount.com"
        }
    }

    traffic {
      percent = 100
      latest_revision = true
    }
}

resource "google_cloud_run_service_iam_member" "name" {
  location    = google_cloud_run_service.my-second-cloudrun-service.location
  project     = var.project_id
  service     = google_cloud_run_service.my-second-cloudrun-service.name
  role = "roles/run.invoker"
  member = "allUsers"

  depends_on = [ google_cloud_run_service.my-second-cloudrun-service ]
}

/* data "google_iam_policy" "noauth" {
    binding {
      role = "roles/run.invoker"
      members = ["allUsers",]
    }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.my-second-cloudrun-service.location
  project     = var.project_id
  service     = google_cloud_run_service.my-second-cloudrun-service.name

  policy_data = data.google_iam_policy.noauth.policy_data
} */

#main branch
