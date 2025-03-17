{{ config(materialized="view") }}

with stg_users as 
(
    select *
    from {{ source("staging", "users") }}
)

select
    *,
    (CAST(SUBSTR(CAST(Num_Acc AS STRING), 1, 4) AS INT64) - an_nais) AS user_age_at_accident,
    {{ get_injury_severity("grav") }} as gravity_description,
    {{ get_user_category("catu") }} as user_category_description,
    {{ get_user_gender("sexe") }} as gender_description

from stg_users

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var("is_test_run", default=true) %} limit 100 {% endif %}



