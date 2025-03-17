{#
    This macro returns the gender of user: 1 - Male ; 2 - Female
#}

{% macro get_user_gender(sexe) -%}

    case {{ dbt.safe_cast("sexe", api.Column.translate_type("integer")) }}
        when 1 then 'Male'
        when 2 then 'Female'
        else 'EMPTY'
    end

{%- endmacro %}