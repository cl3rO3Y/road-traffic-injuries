# Installation and Setup

## 0. Prerequisites

➡️ Install **Terraform**:

   - [General instructions on HashiCorp site](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

  - [Instructions for Ubuntu](/docs/terraform_install_ubuntu.md)

➡️ Install **[Docker Desktop](https://docs.docker.com/get-started/get-docker/)**.

### 1. Google Cloud Setup

1. Navigate to the [Google Cloud Platform Console](https://console.cloud.google.com/) and create an account if you do not already have one.
2. [Create a new Google Project](https://developers.google.com/workspace/guides/create-project). Be sure to record the project ID from the home page of the project in the console.
3. Navigate to the IAM portal in GCP and [create a service account](https://cloud.google.com/iam/docs/service-accounts-create). It is recommended to simply give this account the 'Owner' role, but this is over-permissioned. Feel free to limit permissions as needed.
4. [Create a service account key](https://cloud.google.com/iam/docs/keys-create-delete) for your new service account. Be sure to select JSON download which will create a JSON file with your key and download it to your local system.
5. Copy this downloaded json file into the home directory of your road-traffic-injuries repo previously created. Rename this file `my_creds.json`. This file is ignored with .gitignore so you should not worry about it being added to your repo.

### 2. Terraform Infrastructure

Now that you have a service account with credentials stored in your local repo, you can terraform the cloud infrastructure. The terraform plan will create one bucket and a BigQuery dataset called rti_dataset.

1. Navigate to the `variables.tf` file in the terraform folder of your local repo. Confirm that the variable "credentials" is referencing your service account credentials stored at "../my_creds.json"
2. Also, update the variable "project" with the project ID you created in the previous steps for GCP setup.

  These two steps will connect your service account and project and allow terraform to create infrastructure.

3. Next you can init, plan, and apply the terraform infrastructure from your command line with:

```bash
terraform init
terraform plan
terraform apply
```

You may need to enter yes after planning and applying. Once complete you can navigate to GCP and confirm that the infrastructure has been built.

💡 NOTE: be sure to run `terraform destroy` after working on this project to eliminate those resources and prevent unnecessary spend.

### 3. Docker and Kestra

#### Kestra setup

Launch Kestra in Docker with:

```bash
docker run --pull=always --rm -it -p 8080:8080 --user=root -v /var/run/docker.sock:/var/run/docker.sock -v /tmp:/tmp kestra/kestra:latest server local
```

Kestra is now available here: <http://localhost:8080/>

Add flows programmatically using Kestra's API:

```bash
cd kestra
curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@01_gcp_kv.yaml
curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@02_upload_all.yaml
```

Configure Kestra Key/Values in Kestra's interface in Namespaces->KV Store.

- GCP_CREDS
- GCP_PROJECT_ID
- GCP_LOCATION
- GCP_BUCKET_NAME
- GCP_DATASET.

⚠️ The GCP_CREDS service account contains sensitive information. Ensure you keep it secure and do not commit it to Git. Keep it as secure as your passwords.

### 4. dbt setup

1. Go to https://www.getdbt.com/ and create a free account.
2. Create a dbt project:

    1. In Choose a connection, select BigQuery, add GitHub connection, create dev, and prod environments.
    2. Run Cloud IDE. Click on "Initialize DBT project".
    3. Plan and execute all transformations:

    ```bash
    dbt build --vars '{'is_test_run': 'false'}'
    ```

## Troubleshooting

### BigQuery dataset "not found in location"

Be careful on the location of dbt_rti dataset location.
If you encounter this kind of issue:

```bash
Database Error in model stg_details (models/staging/stg_details.sql)
  Not found: Dataset road-traffic-injuries-453410:dbt_rti was not found in location EU
```

💡 You have to replicate the dataset in BigQuery's interface in your geographic location and then make it the primary location.