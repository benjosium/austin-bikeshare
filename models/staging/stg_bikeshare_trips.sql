{{ config(
    materialized='incremental',
    unique_key='trip_id'
) }}

with source as (
    select
        trip_id,
        subscriber_type,
        bike_id,
        bike_type,
        start_time,
        safe_cast(trim(cast(start_station_id as string)) as int64) as start_station_id,
        trim(start_station_name) as start_station_name,
        safe_cast(trim(cast(end_station_id as string)) as int64) as end_station_id,
        trim(end_station_name) as end_station_name,
        safe_cast(duration_minutes as int64) as duration_minutes,
        date(start_time) as start_date,
        current_timestamp() as ingestion_date
    from {{ source('austin_bikeshare', 'bikeshare_trips') }}
)

select *
from source
where start_station_id is not null
  and start_station_id in (select station_id from {{ source('austin_bikeshare', 'bikeshare_stations') }})
{% if is_incremental() %}
  and start_time > coalesce((select max(start_time) from {{ this }}), timestamp('1970-01-01'))
{% endif %}
