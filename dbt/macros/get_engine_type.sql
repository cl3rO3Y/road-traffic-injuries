{#
    This macro returns the type of vehicle engine: 
    -1 - Unknown ; 
    0 - Unknown ; 
    1 - Hydrocarbon ; 
    2 - Hybrid electric ; 
    3 - Electric ; 
    4 - Hydrogen ; 
    5 - Human ; 
    6 - Other.
#}

{% macro get_engine_type(motor) -%}

    case {{ dbt.safe_cast("motor", api.Column.translate_type("integer")) }}
        when -1 then 'Empty'
        when 0 then 'Unknown'
        when 1 then 'Hydrocarbon'
        when 2 then 'Hybrid electric'
        when 3 then 'Electric'
        when 4 then 'Hydrogen'
        when 5 then 'Human'
        when 6 then 'Other'
        else 'EMPTY'
    end

{%- endmacro %}