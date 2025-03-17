{{ config(
    materialized = 'table'
) }}

-- CTE pour les tables sources
with details as (
    select *
    from {{ ref('stg_details') }}
),

places as (
    select *
    from {{ ref('stg_places') }}
),

users as (
    select *
    from {{ ref('stg_users') }}
),

vehicles as (
    select *
    from {{ ref('stg_vehicles') }}
),

french_cp as (
    select *
    from {{ ref('french_cp') }}
),

french_deps as (
    select *
    from {{ ref('french_deps') }}
)

-- Sélection finale
select 
    d.Num_Acc,
    d.adr,
    d.accident_datetime,
    d.accident_hour,
    d.accident_date,
    d.position,
    d.dep_code,
    dp.dep_name,
    d.com as insee_code,
    c.Code_postal,
    c.Nom_de_la_commune,
    p.vma,
    u.gender_description as gender,
    u.user_age_at_accident,
    v.vehicle_category
from details d

-- Jointure avec les départements
left join french_cp c
    on d.com = c.Code_commune_INSEE

left join french_deps dp
    on d.dep_code = dp.num_dep

-- Jointure avec les lieux
left join places p
    on d.Num_Acc = p.Num_Acc

-- Jointure avec les usagers
left join users u
    on d.Num_Acc = u.Num_Acc

-- Jointure avec les véhicules
left join vehicles v
    on d.Num_Acc = v.Num_Acc
