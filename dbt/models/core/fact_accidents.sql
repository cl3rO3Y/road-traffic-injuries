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

-- 👉 Comptage des usagers par accident
users_count as (
    select
        Num_Acc,
        count(*) as nb_users
    from {{ ref('stg_users') }}
    group by Num_Acc
),

-- 👉 Comptage des véhicules par accident
vehicles_count as (
    select
        Num_Acc,
        count(*) as nb_vehicles
    from {{ ref('stg_vehicles') }}
    group by Num_Acc
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
    uc.nb_users,
    vc.nb_vehicles,

from details d

-- Jointure avec les départements
left join french_cp c
    on d.com = c.Code_commune_INSEE

left join french_deps dp
    on d.dep_code = dp.num_dep

-- Jointure avec les lieux
left join places p
    on d.Num_Acc = p.Num_Acc


-- Jointure avec les agrégats users et véhicules
left join users_count uc
    on d.Num_Acc = uc.Num_Acc

left join vehicles_count vc
    on d.Num_Acc = vc.Num_Acc