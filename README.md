# Airflow with R and the nostR package

This template allows one to run a dockerized implementation of Airflow with support for the `R` programming language and the `nostR` R package.

To build first run:

`docker compose --profile flower plain build`

Then spin up the resources with:

`docker compose --profile flower up -d`

You can spin down the service with:

`docker compose --profile flower down -v`

Place your R scripts in the rscripts folder.

Store dags in the dag folder. Below is an example of a simple hourly dag that runs a sample R script:

```python
from datetime import timedelta
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.utils.dates import days_ago

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': days_ago(1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 0,
}

dag = DAG(
    'run_r_script',
    default_args=default_args,
    description='A simple DAG to run an R script',
    schedule_interval=timedelta(hours=1),
    catchup=False,
)

run_r_script = BashOperator(
    task_id='run_r_script',
    bash_command='Rscript /opt/airflow/rscripts/sample.R',
    dag=dag,
)
```