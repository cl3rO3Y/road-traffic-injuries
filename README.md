# Road traffic injuries in France 🚘 🏥 🤕 🚑

## Project description

Road accidents are a major public safety concern, causing injuries, fatalities, and significant economic losses. This project aims to analyze annual datasets of traffic accidents in France from 2021 to 2023, sourced from [data.gouv.fr](https://www.data.gouv.fr/fr/datasets/bases-de-donnees-annuelles-des-accidents-corporels-de-la-circulation-routiere-annees-de-2005-a-2023/). By leveraging data engineering tools, we will process, clean, and integrate these datasets to uncover key insights, such as accident hotspots, trends over time, and the impact of factors like speed limits, day of week and season.

## Preview

@todo insert screenshot

[Link to the dashboard](https://lookerstudio.google.com/reporting/dc3527bf-b243-4f80-9981-8671b1b15bf2)

## Technologies Used

- **Infrastructure as Code (IaC)**: Terraform
- **Cloud Platform**: GCP (Google Cloud Platform)
- **Data Lake**: GCS Bucket
- **Data Warehouse**: BigQuery
- **Data Transformation**: dbt
- **Dashboard Tool**: Looker Studio
- **Containerization**: Docker
- **Workflow Orchestration**: Kestra

## Data architecture

@todo insert schema
talk about the 4 used datasets and the 2 seeds.

The pipeline comprised the following steps:

Basic data are retrieved from **data.gouv.fr**. They include 4 csv files for each year:

- details (*caractéristiques* in french)
- users (*usagers* in french)
- vehicles (*véhicules* in french)
- places (*lieux* in french)

**Kestra** creates 4 main BigQuery tables (details, users, vehicles, places) and 4 other staging tables.

Each csv file from data.gouv.fr is uploaded by Kestra to a Google Cloud bucket. It is then transformed into a BigQuery staging table. The staging table is then merged with the main table, and truncated.

Then, with **dbt**, we perform a number of clean-ups and improvements:

- keep only data from metropolitan France
- rework the format of dates and identifier fields
- create a real geospatial POINT field,
- transform key values into meaningful names via macros (gravity_description, gender_description etc).

We also add 2 seeds, still supplied by data.gouv.fr:

- *french_departments.csv*: mapping between the codes and the names of the French departments
- *french_postal_codes.csv*: mapping between the INSEE code of a municipality and its name

Finally, we create a **fact_accidents.sql** table which aggregates the data for a given accident as follows:

- number of users involved
- number of users by severity of injury (4 categories: uninjured, slightly injured, hospitalized, killed)
- number of vehicles involved
- city name
- department name
- maximum speed at accident location




## Running the project

## 0. Prerequisites

➡️ **Install Terraform**
- [instructions for Ubuntu](https://www.notion.so/Terraform-1a0f5c23d69f8039ae2af5846bf0a325?pvs=4#1b2f5c23d69f8034bfc3ec22bed031c8)

- [general instructions](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

➡️ **Install [Docker Desktop](https://docs.docker.com/get-started/get-docker/)**.

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

NOTE: be sure to run `terraform destroy` after working on this project to eliminate those resources and prevent unnecessary spend.

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

Warning

The GCP_CREDS service account contains sensitive information. Ensure you keep it secure and do not commit it to Git. Keep it as secure as your passwords.

#### 4. dbt setup

@todo

Be careful on the location of dbt_rti dataset location.
If you encounter this issue:

```bash
Database Error in model stg_details (models/staging/stg_details.sql)
  Not found: Dataset road-traffic-injuries-453410:dbt_rti was not found in location EU
```

you have to replicate the dataset in BigQuery's interface in your geographic location and then make it the primary location.

## Possible Improvements

- Insert older data, from 2005 to 2020 (they have a slightly different schema, requiring additional transformations).

## Acknowledgements

This project was completed as part of [Data Engineering Zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp) - a free course organized by the [DataTalks.Club community](https://datatalks.club/).
