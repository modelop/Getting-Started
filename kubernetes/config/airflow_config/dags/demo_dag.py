from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from datetime import datetime, timedelta
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2018, 5, 21, 12),
    'email': ['airflow@airflow.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),

}

dag = DAG(
    'demo_dag', catchup=False, default_args=default_args, schedule_interval='@daily')

t1 = BashOperator(
    task_id='demo_runner',
    bash_command='bash -x /usr/local/airflow/processing/demo_runner.sh ',
    retries=3,
    dag=dag)

t1
