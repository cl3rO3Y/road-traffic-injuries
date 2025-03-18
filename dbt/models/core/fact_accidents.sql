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

-- number of users by accident
users_count as (
    select
        Num_Acc,
        count(*) as nb_users
    from {{ ref('stg_users') }}
    group by Num_Acc
),

-- number of vehicles by accident
vehicles_count as (
    select
        Num_Acc,
        count(*) as nb_vehicles
    from {{ ref('stg_vehicles') }}
    group by Num_Acc
),

-- number of users by injury type
users_by_injury_type as (
    select
        Num_Acc,
        sum(case when gravity_description = 'Uninjured' then 1 else 0 end) as nb_uninjured,
        sum(case when gravity_description = 'Slightly injured' then 1 else 0 end) as nb_slightly_injured,
        sum(case when gravity_description = 'Hospitalized' then 1 else 0 end) as nb_hospitalized,
        sum(case when gravity_description = 'Killed' then 1 else 0 end) as nb_killed
    from {{ ref('stg_users') }}
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

-- Final selection
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
    -- Add counts for each injury type
    uib.nb_uninjured,
    uib.nb_slightly_injured,
    uib.nb_hospitalized,
    uib.nb_killed

from details d

left join french_cp c
    on d.com = c.Code_commune_INSEE

left join french_deps dp
    on d.dep_code = dp.num_dep

left join places p
    on d.Num_Acc = p.Num_Acc

left join users_count uc
    on d.Num_Acc = uc.Num_Acc

left join vehicles_count vc
    on d.Num_Acc = vc.Num_Acc

left join users_by_injury_type uib
    on d.Num_Acc = uib.Num_Acc