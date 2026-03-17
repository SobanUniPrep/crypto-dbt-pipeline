import os
from dotenv import load_dotenv

load_dotenv()

# API
API_BASE_URL = "https://api.coingecko.com/api/v3"

# Snowflake
SNOWFLAKE_USER = os.getenv("SNOWFLAKE_USER")
SNOWFLAKE_PASSWORD = os.getenv("SNOWFLAKE_PASSWORD")
SNOWFLAKE_ACCOUNT = os.getenv("SNOWFLAKE_ACCOUNT")
SNOWFLAKE_WAREHOUSE = os.getenv("SNOWFLAKE_WAREHOUSE")
SNOWFLAKE_DATABASE = os.getenv("SNOWFLAKE_DATABASE")
SNOWFLAKE_ROLE = os.getenv("SNOWFLAKE_ROLE")
SNOWFLAKE_SCHEMA = "RAW"

# Pipeline
VS_CURRENCY = "usd"
PER_PAGE = 250
MAX_PAGES = 2  # Pro testování, můžete zvýšit pro produkci