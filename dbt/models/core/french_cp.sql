{{ config(materialized='table') }}

select 
    Code_commune_INSEE, 
    Nom_de_la_commune, 
    cast(Code_postal as string) as Code_postal
from {{ ref('french_postal_codes') }}