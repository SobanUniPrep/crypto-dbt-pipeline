import logging
import pandas as pd
import snowflake.connector
from snowflake.connector.pandas_tools import write_pandas
from ingestion import config

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

def get_snowflake_connection():
    conn = snowflake.connector.connect(
        user=config.SNOWFLAKE_USER,
        password=config.SNOWFLAKE_PASSWORD,
        account=config.SNOWFLAKE_ACCOUNT,
        warehouse=config.SNOWFLAKE_WAREHOUSE,
        database=config.SNOWFLAKE_DATABASE,
        role=config.SNOWFLAKE_ROLE,
        schema=config.SNOWFLAKE_SCHEMA
    )
    logger.info("Snowflake connection established")
    return conn

def load_coins(coins: list) -> None:
    df = pd.DataFrame(coins)
    df.columns = [col.upper() for col in df.columns]
    
    conn = get_snowflake_connection()
    success, nchunks, nrows, _ = write_pandas(
        conn=conn,
        df=df,
        table_name="RAW_COINS",
        auto_create_table=True,
        overwrite=True
    )
    logger.info(f"Loaded {nrows} rows in {nchunks} chunks. Success: {success}")
    conn.close()

if __name__ == "__main__":
    from ingestion.extract import extract_all_coins
    coins = extract_all_coins()
    load_coins(coins)