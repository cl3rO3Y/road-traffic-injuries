variable "credentials" {
  description = "My Credentials"
  default     = "../my_creds.json"
}

variable "project" {
  description = "Project"
  default     = "road-traffic-injuries-453410"
}

variable "location" {
  description = "Project Location"
  default     = "EU"
}

variable "region" {
  description = "Region Location"
  default     = "fr-central"
}

variable "bq_dataset_name" {
  description = "My BigQuery dataset name"
  default     = "rti_dataset"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket name"
  default     = "road-traffic-injuries-data-france"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}