{{ config(materialized="view") }}

with stg_places as 
(
    select *
    from {{ source("staging", "places") }}
)

select
    Num_Acc, vma

from stg_places

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var("is_test_run", default=true) %} limit 100 {% endif %}



