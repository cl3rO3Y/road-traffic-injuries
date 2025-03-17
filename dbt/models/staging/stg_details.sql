{{ config(materialized="view") }}

with stg_details as 
(
    select *
    from {{ source("staging", "details") }}
    where dep NOT IN ('971', '972', '973', '974', '975', '976', '977', '978', '984', '986', '987', '988', '989')
)

select
    Num_Acc, dep, com, adr,
    -- Construction d'une chaîne au format DATETIME : "YYYY-MM-DD HH:MM:00"
    datetime(
        date(an, mois, jour),  -- Crée une date à partir des colonnes an, mois, jour
        time(
            cast(substr(hrmn, 1, 2) as int64),  -- Extraction de l'heure (HH)
            cast(substr(hrmn, 4, 2) as int64),  -- Extraction des minutes (MM)
            0  -- Secondes à 0
        )
    ) as accident_datetime,

    -- Heure extraite à partir du champ DATETIME
    extract(
        hour
        from
            datetime(
                date(an, mois, jour),
                time(
                    cast(substr(hrmn, 1, 2) as int64),
                    cast(substr(hrmn, 4, 2) as int64),
                    0
                )
            )
    ) as accident_hour,

    -- Date seule
    date(an, mois, jour) as accident_date,

    lat / 100000000 as lat_corrected,
    long / 100000000 as long_corrected,

-- Création d'un champ 'position' de type POINT à partir des coordonnées lat et long
    st_geogpoint(long / 100000000, lat / 100000000) as position
from stg_details

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var("is_test_run", default=true) %} limit 100 {% endif %}



