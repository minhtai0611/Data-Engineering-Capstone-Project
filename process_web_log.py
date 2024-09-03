from datetime import datetime
from airflow import DAG

default_args = {
    'owner': 'TRUONG MINH TAI',
    'start_date': datetime(2024, 9, 2),
    'email': ['minhtainth06111999@.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1
}

dag = DAG(
    'process_web_log',
    default_args=default_args,
    description='A simple DAG to process web server logs',
    schedule_interval='@daily',
    catchup=False
)

from airflow.operators.python_operator import PythonOperator

def extract_data():
    with open('/home/project/airflow/dags/capstone/accesslog.txt', 'r') as logfile, open('/home/project/airflow/dags/capstone/extracted_data.txt', 'w') as output_file:
        for line in logfile:
            ip_address = line.split(' ')[0]
            output_file.write(ip_address + '\n')

extract_task = PythonOperator(
    task_id='extract_data',
    python_callable=extract_data,
    dag=dag
)

def transform_data():
    with open('/home/project/airflow/dags/capstone/extracted_data.txt', 'r') as input_file, open('/home/project/airflow/dags/capstone/transformed_data.txt', 'w') as output_file:
        for line in input_file:
            if '198.46.149.143' not in line:
                output_file.write(line)

transform_task = PythonOperator(
    task_id='transform_data',
    python_callable=transform_data,
    dag=dag
)

import tarfile

def load_data():
    with tarfile.open('/home/project/airflow/dags/capstone/weblog.tar', 'w') as tar:
        tar.add('/home/project/airflow/dags/capstone/transformed_data.txt')

load_task = PythonOperator(
    task_id='load_data',
    python_callable=load_data,
    dag=dag
)

extract_task >> transform_task >> load_task




