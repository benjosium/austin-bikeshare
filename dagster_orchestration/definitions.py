from dagster import Definitions
from dagster_orchestration.jobs.example_job import example_job

defs = Definitions(jobs=[example_job])

