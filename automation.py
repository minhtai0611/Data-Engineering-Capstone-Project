# Import libraries required for connecting to mysql

# Import libraries required for connecting to DB2 or PostgreSql

# Connect to MySQL

# Connect to DB2 or PostgreSql
import mysql.connector
import psycopg2

# Find out the last rowid from DB2 data warehouse or PostgreSql data warehouse
# The function get_last_rowid must return the last rowid of the table sales_data on the IBM DB2 database or PostgreSql.

def get_last_rowid():
    try:
        # Connect to PostgreSQL data warehouse
        conn = psycopg2.connect(
            host="172.21.200.213",
            database="sales",
            user="postgres",
            password="QiD5Ldh2Gl1Ilef019Zd7aja"
        )
        cur = conn.cursor()
        
        # Query to get the last rowid from the sales_data table
        cur.execute("SELECT MAX(rowid) FROM sales_data")
        last_row_id = cur.fetchone()[0]
        
        # Close connections
        cur.close()
        conn.close()
        
        return last_row_id

    except Exception as error:
        print(f"Error: {error}")
        return None

last_row_id = get_last_rowid()
print("Last row id on production datawarehouse = ", last_row_id)

# List out all records in MySQL database with rowid greater than the one on the Data warehouse
# The function get_latest_records must return a list of all records that have a rowid greater than the last_row_id in the sales_data table in the sales database on the MySQL staging data warehouse.

def get_latest_records(rowid):
    try:
        # Connect to MySQL staging data warehouse
        conn = mysql.connector.connect(
            host="172.21.185.162",
            database="sales",
            user="root",
            password="6IRYIVgitugwLnI3yitCxlm3"
        )
        cur = conn.cursor(dictionary=True)
        
        # Query to get all records with rowid > last_row_id
        query = "SELECT * FROM sales_data WHERE rowid > %s"
        cur.execute(query, (last_row_id,))
        
        new_records = cur.fetchall()
        
        # Close connections
        cur.close()
        conn.close()
        
        return new_records

    except Exception as error:
        print(f"Error: {error}")
        return []	

new_records = get_latest_records(last_row_id)

print("New rows on staging datawarehouse = ", len(new_records))

# Insert the additional records from MySQL into DB2 or PostgreSql data warehouse.
# The function insert_records must insert all the records passed to it into the sales_data table in IBM DB2 database or PostgreSql.

def insert_records(records):
    try:
        # Connect to PostgreSQL data warehouse
        conn = psycopg2.connect(
            host="172.21.200.213",
            database="sales",
            user="postgres",
            password="QiD5Ldh2Gl1Ilef019Zd7aja"
        )
        cur = conn.cursor()
        
        # Insert new records into sales_data
        for record in records:
            insert_query = """
            INSERT INTO sales_data (rowid, product_id, customer_id, price, quantity, timeestamp)
            VALUES (%d, %d, %d, %d, %d, %s)"""
            cur.execute(insert_query, (record['rowid'], record['product_id'], record['customer_id'], record['price'], record['quantity'], record['timeestamp']))
        
        # Commit the changes
        conn.commit()
        
        # Close connections
        cur.close()
        conn.close()

    except Exception as error:
        print(f"Error: {error}")

insert_records(new_records)
print("New rows inserted into production datawarehouse = ", len(new_records))

# disconnect from mysql warehouse

# disconnect from DB2 or PostgreSql data warehouse 

# End of program