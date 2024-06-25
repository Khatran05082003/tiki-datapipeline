from google.cloud import bigquery
import os

service_account_path = "service_account.json"
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = service_account_path

client = bigquery.Client()


project_id = 'dwproject-424604'  
dataset_id = 'dataset'  
dataset_ref = f'{project_id}.{dataset_id}'


dataset = bigquery.Dataset(dataset_ref)


try:
    client.create_dataset(dataset)
    print(f"Dataset {dataset_id} created successfully.")
except Exception as e:
    print(f"Error creating dataset: {e}")


table_id = 'product'  
table_ref = f'{dataset_ref}.{table_id}'





table = bigquery.Table(table_ref)


try:
    client.create_table(table)
    print(f"Table {table_id} created successfully in dataset {dataset_id}.")
except Exception as e:
    print(f"Error creating table: {e}")