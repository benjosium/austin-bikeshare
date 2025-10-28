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
        modified_date,
        current_timestamp() as ingestion_date
    from {{ source('austin_bikeshare', 'bikeshare_stations') }}
)

select *
from source

{% if is_incremental() %}
    where modified_date > (select max(modified_date) from {{this}})
{% endif %}