# uid2-infrastructure
This repository defines the infrastructure required to run uid2 services. CircleCI workflows are configured to implement three environments matching three branches of git repository: live-dev, live-qa and live-prod.
uid2 services are expected to be deployed on top of this infrastructure using their own CI/CD pipeline(s) and tools such as Harness CD.

# Getting started
In order to get the environment running several manual prep-steps need to be performed. While uid2 service itself is designed and will run on multiple clouds (AWS, GCP, Azure), GCP project is required to host central management components and referred in code as "mission control". At this time mission control only contains centralized prometheus+grafana installation, but can be possibly extended further should some coordination or aggregation of data needed from multiple clouds and regions.
Several configuration settings are required to get infrastructure going. These settings are mostly set and forget and will rarely need to be modified in the future:
- GCP project. It is expected that uid2-infrastructure does not share project with anything. It is both best and common practice.
```
export GCP_PROJECT=<project-name>
gcloud projects create $GCP_PROJECT

```
- CloudDNS domain. CloudDNS domain needs to be pre-created manually and domain's NS records must pointing to this CloudDNS domain. In some cases it is feasable to obtain DNS domain using Cloud Domains service. Default CloudDNS domain name id that terraform tries to discover is `uid2-0`.
```
gcloud dns managed-zones create uid2-0 --description "UID2 serving domain" --dns-name uid2-0 --project $GCP_PROJECT
```
- create `terraform` user in GCP project and grant Owner permissions to it
```
gcloud iam service-accounts create terraform --description="Terraform service account" \ --display-name="Terraform"
gcloud projects add-iam-policy-binding $GCP_PROJECT --member="serviceAccount:terraform@${GCP_PROJECT}.iam.gserviceaccount.com" --role="roles/owner"
```
- create service account key for `terraform` user
```
gcloud iam service-accounts keys create key.json --iam-account=terraform@${GCP_PROJECT}.iam.gserviceaccount.com
cat key.json |tr -d '\n'
```
- create GCS bucket for terraform state
```
gsutil mb gs://${GCS_PROJECT} -p $GCS_PROJECT -b
```
- CircleCI: create environment variables with matching enviroment prefix. For example: `qa_GOOGLE_PROJECT`


| CircleCI variable name      | Description                                                                                              | Format    |Required? |
| --------------------------- | -------------------------------------------------------------------------------------------------------- | --------- | -------- |
| \<env>_GOOGLE_PROJECT        | Name of the GCP project for the environment. All GKE clusters including mission control will be created here                          | plaintext | yes      |
| \<env>_TERRAFORM_BACKEND_B64 | Terraform snippet defining backend pointing to the bucket created in previous step                       | base64    | yes      |
| \<env>_TF_VAR_regions_B64    | List of regions across multiple clouds, for example `[ "us-east1", "us-west-1", "US West" ]`                | tf var    | yes      |
| \<env>_GOOGLE_CREDENTIALS    | Terraform GCP service account json generated in previous step                                                                       | json      | yes      |
| \<env>_AWS_ACCESS_KEY_ID     | Terraform AWS Access Key ID                                                                              | plaintext | no       |
| \<env>_AWS_SECRET_ACCESS_KEY | Terraform AWS Secret Access Key                                                                          | plaintext | no       |

