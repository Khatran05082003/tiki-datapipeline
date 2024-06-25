from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.utils.dates import days_ago
import subprocess

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
}

dag = DAG(
    'product_pipeline',
    default_args=default_args,
    description='A simple product pipeline',
    schedule_interval='@daily',
    start_date=days_ago(1),
)

def run_script(script_name):
    subprocess.run(['python', f'/home/khatran0508/script/{script_name}'], check=True)

def run_soda_checks():
    subprocess.run(['python', '/home/khatran0508/soda/check.py'], check=True)

with dag:
    crawl_product = PythonOperator(
        task_id='crawl_product',
        python_callable=run_script,
        op_args=['crawl_product.py'],
    )

    mongo_to_file = PythonOperator(
        task_id='mongo_to_file',
        python_callable=run_script,
        op_args=['mongo_to_file.py'],
    )

    create_empty_dataset_table = PythonOperator(
        task_id='create_empty_dataset_table',
        python_callable=run_script,
        op_args=['create_empty_dataset_table.py'],
    )

    soda_check = PythonOperator(
        task_id='soda_check',
        python_callable=run_soda_checks,
    )

    file_to_bigquery = PythonOperator(
        task_id='file_to_bigquery',
        python_callable=run_script,
        op_args=['file_to_bigquery.py'],
    )

    dbt_transform = PythonOperator(
        task_id='dbt_transform',
        python_callable=run_script,
        op_args=['dbt_transform.py'],
    )

    crawl_product >> mongo_to_file >> create_empty_dataset_table >> soda_check >> file_to_bigquery >> dbt_transform
