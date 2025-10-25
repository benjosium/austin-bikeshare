{{config(
    materialized='incremental',
    unique_key='station_id'
) }}

with source as (
    select
        station_id,
        name,
        status,
        location,
        address,
        alternate_name,
        city_asset_number,
        property_type,
        number_of_docks,
        power_type,
        footprint_length,
        footprint_width,
        notes,
        council_district,
        image,
        modified_date
    from `austin-bikeshare-476201.austin_bikeshare.bikeshare_stations`
)

select *
from source

{% if is_incremental() %}
    where modified_date > (select max(modified_date) from {{this}})
{% endif %}