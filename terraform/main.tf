provider "google" {
    project = var.project_id
    region = var.region_name
}

resource "google_cloud_run_service" "my-second-cloud-run-service" {
    name = var.service_name
    location = var.service_location
    template {
        spec {
          containers {
            image="us-east1-docker.pkg.dev/manojproject1-396309/githubaction-testing-cloudrun1/myimage1"
          }
        }
    }

    traffic {
      percent = 100
      latest_revision = true
    }
}

data "google_iam_policy" "noauth" {
    binding {
      role = "roles/run.invoker"
      members = ["allusers"]
    }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.my-second-cloudrun-service.location
  project     = var.project_id
  service     = google_cloud_run_service.my-second-cloudrun-service.name

  policy_data = data.google_iam_policy.noauth.policy_data
}