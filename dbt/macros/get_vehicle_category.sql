{#
    This macro returns the vehicle category: 
    00 - Undetermined
    01 - Bicycle
    02 - Moped <50cm3
    03 - Voiturette (Quadricycle à moteur carrossé) (formerly “voiturette ou tricycle à moteur”)
    04 - Reference unused since 2006 (registered scooter)
    05 - Reference unused since 2006 (motorcycle)
    06 - Reference unused since 2006 (sidecar)
    07 - LV only
    08 - Reference unused since 2006 (LV + caravan)
    09 - Reference unused since 2006 (car + trailer)
    10 - LCV only 1.5T <= GVWR <= 3.5T with or without trailer (formerly LCV only 1.5T <= GVWR
    <= 3,5T)
    11 - Reference unused since 2006 (LCV (10) + trailer)
    12 - Reference unused since 2006 (LCV (10) + trailer)
    13 - Truck only 3.5T <PTCA <= 7.5T
    14 - Truck only > 7.5T
    15 - Truck > 3.5T + trailer
    16 - Truck tractor only
    17 - Road tractor + semi-trailer
    18 - Reference unused since 2006 (public transport)
    19 - Reference unused since 2006 (tramway)
    20 - Special machine
    21 - Agricultural tractor
    30 - Scooter < 50 cm3
    31 - Motorcycle > 50 cm3 and <= 125 cm3
    32 - Scooter > 50 cm3 and <= 125 cm3
    33 - Motorcycle > 125 cm3
    34 - Scooter > 125 cm3
    35 - Light quad <= 50 cm3 (motor quadricycle without body)
    36 - Heavy quad > 50 cm3 (Quadricycle without body)
    37 - Bus
    38 - Coach
    39 - Train
    40 - Tramway
    41 - 3WD <= 50 cm3
    42 - 3WD > 50 cm3 <= 125 cm3
    43 - 3WD > 125 cm3
    50 - EDP with motor
    60 - EDP without motor
    80 - VAE
    99 - Other vehicle
#}

{% macro get_vehicle_category(catv) -%}

    case {{ dbt.safe_cast("catv", api.Column.translate_type("integer")) }}
        when 0 then 'Undetermined'
        when 1 then 'Bicycle'
        when 2 then 'Moped <50cm3'
        when 3 then 'Voiturette (Quadricycle à moteur carrossé) (formerly “voiturette ou tricycle à moteur”)'
        when 4 then 'Reference unused since 2006 (registered scooter)'
        when 5 then 'Reference unused since 2006 (motorcycle)'
        when 6 then 'Reference unused since 2006 (sidecar)'
        when 7 then 'LV only'
        when 8 then 'Reference unused since 2006 (LV + caravan)'
        when 9 then 'Reference unused since 2006 (car + trailer)'
        when 10 then 'LCV only 1.5T <= GVWR <= 3.5T with or without trailer (formerly LCV only 1.5T <= GVWR <= 3.5T)'
        when 11 then 'Reference unused since 2006 (LCV (10) + trailer)'
        when 12 then 'Reference unused since 2006 (LCV (10) + trailer)'
        when 13 then 'Truck only 3.5T <PTCA <= 7.5T'
        when 14 then 'Truck only > 7.5T'
        when 15 then 'Truck > 3.5T + trailer'
        when 16 then 'Truck tractor only'
        when 17 then 'Road tractor + semi-trailer'
        when 18 then 'Reference unused since 2006 (public transport)'
        when 19 then 'Reference unused since 2006 (tramway)'
        when 20 then 'Special machine'
        when 21 then 'Agricultural tractor'
        when 30 then 'Scooter < 50 cm3'
        when 31 then 'Motorcycle > 50 cm3 and <= 125 cm3'
        when 32 then 'Scooter > 50 cm3 and <= 125 cm3'
        when 33 then 'Motorcycle > 125 cm3'
        when 34 then 'Scooter > 125 cm3'
        when 35 then 'Light quad <= 50 cm3 (motor quadricycle without body)'
        when 36 then 'Heavy quad > 50 cm3 (Quadricycle without body)'
        when 37 then 'Bus'
        when 38 then 'Coach'
        when 39 then 'Train'
        when 40 then 'Tramway'
        when 41 then '3WD <= 50 cm3'
        when 42 then '3WD > 50 cm3 <= 125 cm3'
        when 43 then '3WD > 125 cm3'
        when 50 then 'EDP with motor'
        when 60 then 'EDP without motor'
        when 80 then 'VAE'
        when 99 then 'Other vehicle'
        else 'EMPTY'
    end

{%- endmacro %}