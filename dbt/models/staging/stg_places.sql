{{ config(materialized="table") }}

with stg_places as 
(
    select *
    from {{ source("staging", "places") }}
)

select
    {{ dbt.safe_cast("Num_Acc", api.Column.translate_type("string")) }} as Num_Acc,
    vma

from stg_places

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var("is_test_run", default=true) %} limit 1000 {% endif %}



