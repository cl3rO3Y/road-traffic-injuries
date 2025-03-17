{{ config(materialized="view") }}

with stg_vehicles as 
(
    select *
    from {{ source("staging", "vehicles") }}
)

select
    Num_Acc, id_vehicule, num_veh,
    {{ get_engine_type("motor") }} as engine_description,
    {{ get_vehicle_category("catv") }} as vehicle_category

from stg_vehicles

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var("is_test_run", default=true) %} limit 100 {% endif %}



