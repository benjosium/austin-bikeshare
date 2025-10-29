from dagster import job, op

@op
def hello():
    print("Hola desde Dagster!")

@job
def example_job():
    hello()
