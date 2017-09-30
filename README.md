# Kubernetes + Prometheus + Grafana

## Step 1: Provision a Kubernetes cluster

### Locally, using Minikube

### On GKE, using Terraform

- Install Terraform:

  - On macOS: `brew install terraform`
  - On Linux (standalone): download the latest binary from [here](https://www.terraform.io/downloads.html)
  - On Linux (via Aptitude): `sudo apt install terraform`
  - For other platforms or more details, see [here](https://www.terraform.io/intro/getting-started/install.html)

- Set the below environment variables:
```
export GOOGLE_CREDENTIALS_FILE="/path/to/google/credentials/file.json"
export GOOGLE_CREDENTIALS=$(cat "$GOOGLE_CREDENTIALS_FILE")
```

- Run:
```
$ cd prov
$ terraform init
$ terraform apply
```

- Go to https://console.cloud.google.com/kubernetes/list.

- Click on "Connect" for your project, copy & run the `gcloud container clusters get-credentials` command.
  Your `kubectl` is now configured to talk to the GKE cluster.
  N.B.: You can see all available contexts and switch from one to anoother using respectively:
```
$ kubectl config get-contexts
$ kubectl config use-context
```

- Prometheus requires a set of roles to be created in Kubernetes. To be able to add theses, you need to disable legacy RBAC:
```
$ gcloud container clusters list  # and keep track of NAME for your cluster
$ gcloud container clusters update <NAME> --no-enable-legacy-authorization
```

- Go to "IAM & admin" > "IAM" and grant "Container" > "Cluster Admin" role to your user.
- Grant the right permissions to your user (see also [here](https://coreos.com/operators/prometheus/docs/latest/troubleshooting.html)):
```
$ gcloud info | grep Account
Account: [xxx@developer.gserviceaccount.com]
$ kubectl create clusterrolebinding xxx-cluster-admin-binding --clusterrole=cluster-admin --user="xxx@developer.gserviceaccount.com"
```
