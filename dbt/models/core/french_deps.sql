{{ config(materialized='table') }}

select 
    cast(num_dep as string) as num_dep,
    dep_name,
    region_name
from {{ ref('french_departments') }}