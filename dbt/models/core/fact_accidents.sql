{{ config(materialized="table") }}

with
    details as (select * from {{ ref("stg_details") }}),
    places as (
        select num_acc, vma, row_number() over (partition by num_acc order by vma) as rn
        from {{ ref("stg_places") }}
    ),

    -- number of users by accident, without duplicates
    users_count as (
        select num_acc, count(distinct id_usager) as nb_users
        from {{ ref("stg_users") }}
        group by num_acc
    ),

    -- number of vehicles by accident
    vehicles_count as (
        select num_acc, count(*) as nb_vehicles
        from {{ ref("stg_vehicles") }}
        group by num_acc
    ),

    -- number of users by injury type
    users_by_injury_type as (
        select
            num_acc,
            sum(
                case when gravity_description = 'Uninjured' then 1 else 0 end
            ) as nb_uninjured,
            sum(
                case when gravity_description = 'Slightly injured' then 1 else 0 end
            ) as nb_slightly_injured,
            sum(
                case when gravity_description = 'Hospitalized' then 1 else 0 end
            ) as nb_hospitalized,
            sum(case when gravity_description = 'Killed' then 1 else 0 end) as nb_killed
        from {{ ref("stg_users") }}
        group by num_acc
    ),

    french_cp as (
        select
            code_commune_insee,
            code_postal,
            nom_de_la_commune,
            row_number() over (
                partition by code_commune_insee order by code_postal
            ) as rn
        from {{ ref("french_cp") }}
    ),

    french_deps as (select * from {{ ref("french_deps") }})

-- Final selection
select
    d.num_acc,
    d.adr,
    d.accident_datetime,
    d.accident_hour,
    d.accident_date,
    d.position,
    d.dep_code,
    dp.dep_name,
    d.com as insee_code,
    c.code_postal,
    c.nom_de_la_commune,
    p.vma,
    uc.nb_users,
    vc.nb_vehicles,
    -- Add counts for each injury type
    uib.nb_uninjured,
    uib.nb_slightly_injured,
    uib.nb_hospitalized,
    uib.nb_killed

from details d

left join users_count uc on d.num_acc = uc.num_acc

left join users_by_injury_type uib on d.num_acc = uib.num_acc

left join vehicles_count vc on d.num_acc = vc.num_acc

left join
    (
        select code_commune_insee, code_postal, nom_de_la_commune
        from french_cp
        where rn = 1  -- Keep only the 1st recording for each INSEE city
    ) c
    on d.com = c.code_commune_insee

left join french_deps dp on d.dep_code = dp.num_dep

left join
    (
        select num_acc, vma from places where rn = 1  -- Keep only the 1st recording for each Num_Acc
    ) p
    on d.num_acc = p.num_acc
