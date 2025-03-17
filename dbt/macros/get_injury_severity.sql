{#
    This macro returns the severity of user injury, 
    accident victims are classified into three categories of victims plus those uninjured: 
    1 - Uninjured ; 
    2 - Killed ; 
    3 - Hospitalized ; 
    4 - Slightly injured
#}

{% macro get_injury_severity(grav) -%}

    case {{ dbt.safe_cast("grav", api.Column.translate_type("integer")) }}
        when 1 then 'Uninjured'
        when 2 then 'Killed'
        when 3 then 'Hospitalized'
        when 4 then 'Slightly injured'
        else 'EMPTY'
    end

{%- endmacro %}