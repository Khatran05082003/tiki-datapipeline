![image](https://github.com/Khatran05082003/tiki-datapipeline/assets/102920168/2e84f4dc-7ea2-4e3d-9b35-e50facf70f0c)# Dự Án Data Pipeline Tiki

## Giới Thiệu

Dự án này thực hiện quy trình tự động hóa cho việc crawl dữ liệu từ Tiki, lưu trữ vào MongoDB, trích xuất các cột cần thiết ra file CSV, kiểm tra dữ liệu bằng Soda, load dữ liệu vào Google BigQuery, và cuối cùng thực hiện data modeling theo dạng star schema sử dụng DBT (Data Build Tool). Toàn bộ quy trình này được tự động hóa bằng Apache Airflow.

## Quy Trình

1. **Crawl Dữ Liệu Từ Tiki**:
   - Sử dụng script `crawl_product.py` để lấy dữ liệu từ Tiki và lưu vào MongoDB.

2. **Load Dữ Liệu Từ MongoDB và Trích Xuất ra File CSV**:
   - Sử dụng script `mongo_to_file.py` để load dữ liệu từ MongoDB, chọn các cột cần thiết và trích xuất ra file CSV.

3. **Kiểm Tra Dữ Liệu Bằng Soda**:
   - Sử dụng Soda để kiểm tra chất lượng dữ liệu trong file CSV.

4. **Load Dữ Liệu Vào Google BigQuery**:
   - Sử dụng script `file_to_bigquery.py` để load dữ liệu từ file CSV vào Google BigQuery.

5. **Data Modeling Với DBT**:
   - Sử dụng script `dbt_transform.py` để thực hiện data modeling theo dạng star schema trên Google BigQuery.

6. **Tự Động Hóa Quy Trình Bằng Apache Airflow**:
   - Sử dụng Apache Airflow để tự động hóa toàn bộ quy trình trên với DAG `product_pipeline`.

## Cài Đặt

### Yêu Cầu

- Python 3.x
- Apache Airflow
- MongoDB
- Google BigQuery
- Soda
- DBT

### Hướng Dẫn Cài Đặt

1. **Cài Đặt Các Thư Viện Cần Thiết**:
   pip install apache-airflow pymongo google-cloud-bigquery soda-sql dbt
2. **Cấu Hình Google Cloud Service Account**:
Tạo và tải về file service_account.json.
3. **Thêm file này vào .gitignore để tránh lưu thông tin nhạy cảm vào Git**:
sh
Copy code
echo "service_account.json" >> .gitignore
git add .gitignore
git commit -m "Add service_account.json to .gitignore"
4. **Cấu Hình DBT**:

Tạo file profiles.yml cho DBT với cấu hình kết nối tới BigQuery.
5. **Cấu Hình Airflow**:

Cài đặt và cấu hình Apache Airflow .
6. **Tạo DAG cho Airflow**:

Tạo DAG product_pipeline với nội dung sau:
python
Copy code
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
    subprocess.run(['python', f'/path/to/scripts/{script_name}'], check=True)

def run_soda_checks():
    subprocess.run(['python', '/path/to/soda/checks/check.py'], check=True)

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

    crawl_product >> mongo_to_file >> create_empty_da7. **Sử Dụng**
Khởi Động Airflow:

sh
Copy code
airflow db init
airflow webserver --port 8080
airflow scheduler
Truy Cập Giao Diện Airflow:

Mở trình duyệt và truy cập http://localhost:8080.
Chạy DAG product_pipeline:

Kích hoạt và chạy DAG product_pipeline từ giao diện Airflow.
Kiểm Tra Kết Quả:

Kiểm tra các bước đã chạy trong DAG để đảm bảo rằng dữ liệu đã được crawl, xử lý, kiểm tra, load vào BigQuery và thực hiện data modeling thành công.
## Kết Luận
Dự án này cung cấp một quy trình tự động hóa hoàn chỉnh từ việc crawl dữ liệu, kiểm tra chất lượng dữ liệu, đến việc load và transform dữ liệu sử dụng các công cụ hiện đại như Airflow, Soda, BigQuery và DBT. Hy vọng rằng dự án này sẽ giúp bạn hiểu rõ hơn về cách xây dựng một data pipeline hoàn chỉnh và áp dụng vào các dự án thực tế.

## Demo
**MongoDB**
![image](https://github.com/Khatran05082003/tiki-datapipeline/assets/102920168/c31a68c9-6216-4870-b4a4-d907c73140e5)

**Google Bigquery**
![image](https://github.com/Khatran05082003/tiki-datapipeline/assets/102920168/e8305015-e47b-4e77-9a0a-a60c1b8e8c56)

**Model**
![image](https://github.com/Khatran05082003/tiki-datapipeline/assets/102920168/fb0ddf2d-0418-4d97-89b9-c1b7343e4f42)




