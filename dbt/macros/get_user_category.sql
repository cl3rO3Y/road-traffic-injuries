{#
    This macro returns the user category: 
    1 - Driver ; 2 - Passenger ; 3 - Pedestrian
#}

{% macro get_user_category(catu) -%}

    case {{ dbt.safe_cast("catu", api.Column.translate_type("integer")) }}
        when 1 then 'Driver'
        when 2 then 'Passenger'
        when 3 then 'Pedestrian'
        else 'EMPTY'
    end

{%- endmacro %}