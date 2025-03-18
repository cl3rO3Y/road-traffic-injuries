{{ config(materialized="table") }}

with stg_details as 
(
    select *
    from {{ source("staging", "details") }}
    where dep NOT IN ('971', '972', '973', '974', '975', '976', '977', '978', '984', '986', '987', '988', '989')
)

select
    {{ dbt.safe_cast("Num_Acc", api.Column.translate_type("string")) }} as Num_Acc,
    dep as dep_code, 
    com, 
    adr,
    -- Build a string in DATETIME format : "YYYY-MM-DD HH:MM:00"
    datetime(
        date(an, mois, jour),  -- Build a date from "an", "mois", "jour" columns
        time(
            cast(substr(hrmn, 1, 2) as int64),  -- Extraction de l'heure (HH)
            cast(substr(hrmn, 4, 2) as int64),  -- Extraction des minutes (MM)
            0  -- Secondes à 0
        )
    ) as accident_datetime,

    -- Extracted hour from DATETIME field
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

    -- Date only
    date(an, mois, jour) as accident_date,

    lat,
    long,
    -- Field 'position' (POINT type) from lat and long coordinates
    st_geogpoint(long, lat) as position
from stg_details

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var("is_test_run", default=true) %} limit 1000 {% endif %}



