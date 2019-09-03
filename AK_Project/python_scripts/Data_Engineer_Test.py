from __future__ import print_function
from airflow.operators import PythonOperator
from airflow.models import DAG
from datetime import datetime

args = {
    'owner': 'Nitin',
    'start_date': datetime.now(),
	'email':['nitsmali@hotmail.com'],
	'email_on_failure':False,
	'email_on_retry':False,
}

dag = DAG(
    dag_id='Data_Engineer_Test', default_args=args,
    schedule_interval='0 * * * *')
	
def user():
    return 'User has sent email {}'	
	
def email():
    return 'Email has been has sucess {}'
	
	
def Data_Loading():
    print(i)
    return 'Data Loading has been has sucess {}'
	
def Data_Processing():
    print(i)
    return 'Data Processing has been has sucess {}'
	

def extract():
    return 'File has been extracted {}'
	
def checkdb():
    return 'Db has been created{}'
	
def masterscript():
    return 'script processed{}'

t0 = \
    PythonOperator(
        task_id='User',
        python_callable=user,
        dag=dag)	

t1 = \
    PythonOperator(
        task_id='Email_try_yes',
        python_callable=email,
        dag=dag)	


t2 = \
    PythonOperator(
        task_id='Check_db',
        python_callable=checkdb,
        dag=dag)

t3 = \
    PythonOperator(
        task_id='Email_notify',
        python_callable=email,
        dag=dag)		
		
	
t4 = \
    PythonOperator(
        task_id='Data_Loading_Try',
        python_callable=Data_Loading,
        dag=dag)
		
t5 = \
    PythonOperator(
        task_id='Email_notify2',
        python_callable=email,
        dag=dag)
		
t6 = \
    PythonOperator(
        task_id='Master_Script_1',
        python_callable=masterscript,
        dag=dag)
			
t7 = \
    PythonOperator(
        task_id='Master_Script_2',
        python_callable=masterscript,
        dag=dag)
	
t8 = \
    PythonOperator(
        task_id='Data_Processing',
        python_callable=masterscript,
        dag=dag)
		


t9 = \
    PythonOperator(
        task_id='Files_has_extracted',
        python_callable=extract,
        dag=dag)
		
t10 = \
    PythonOperator(
        task_id='Email_notify3',
        python_callable=email,
        dag=dag)
		
		
t1.set_downstream(t0)
t1.set_downstream(t2)
t2.set_downstream(t3)
t3.set_downstream(t0)
t3.set_downstream(t4)
t4.set_downstream(t5)
t5.set_downstream(t0)
t5.set_downstream(t6)
t6.set_downstream(t8)
t8.set_downstream(t9)
t8.set_downstream(t0)
t5.set_downstream(t7)
t7.set_downstream(t8)
t5.set_downstream(t8)
t9.set_downstream(t10)
t10.set_downstream(t0)


