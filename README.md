# Crypto dbt Pipeline

A production-grade data engineering portfolio project showcasing modern data stack skills.
Built as part of interview preparation for a Data Engineer role.

## Architecture
```
CoinGecko API
     ↓
Python Ingestion (pagination, write_pandas)
     ↓
Snowflake RAW schema
     ↓
dbt Staging (cleaning, typing, JSON flatten)
     ↓
dbt Marts (incremental models, Cortex AI)
dbt Vault (Hub, Link, Satellite - Data Vault 2.0)
```

## Tech Stack

- **Python** — API ingestion with pagination, Snowflake connector, write_pandas
- **Snowflake** — Data warehouse, Streams, Tasks, Zero-Copy Cloning, Cortex AI
- **dbt** — Staging, Marts, Data Vault, incremental models, tests, seeds, macros, docs

## Project Structure
```
crypto-dbt-pipeline/
├── ingestion/
│   ├── config.py          # Environment variables
│   ├── extract.py         # CoinGecko API with pagination
│   ├── load.py            # Snowflake write_pandas loader
│   └── main.py            # Pipeline orchestrator
├── dbt_crypto/
│   ├── models/
│   │   ├── staging/       # stg_coins (view, JSON flatten)
│   │   ├── marts/         # mart_coins (incremental), mart_coin_risk_summary (Cortex AI)
│   │   └── vault/         # hub_coin, hub_currency, link_coin_currency, sat_coin_market_data
│   ├── seeds/             # coin_categories.csv
│   ├── tests/             # Singular tests (business logic)
│   ├── macros/            # generate_schema_name, incremental_filter
│   └── dbt_project.yml
├── requirements.txt
├── .env.example
└── README.md
```

## Key Features

### Python Ingestion
- Pagination with rate limit handling (`time.sleep`)
- `write_pandas` for efficient bulk loading
- Structured logging with `logging` module
- Environment variables via `python-dotenv`

### Snowflake Setup
- Dedicated database, warehouse, 4 schemas (RAW, STAGING, MARTS, VAULT)
- Role-based access control (CRYPTO_ADMIN, CRYPTO_DBT, CRYPTO_ANALYST)
- Zero-Copy Clone for dev/test environment (`CRYPTO_DB_DEV`)
- Stream + Task for pipeline automation
- Cortex AI (`COMPLETE()`) for investment risk summaries

### dbt Models
| Model | Type | Schema | Description |
|-------|------|--------|-------------|
| `stg_coins` | View | STAGING | Cleaned, typed, JSON flattened |
| `mart_coins` | Incremental | MARTS | Current state + categories |
| `mart_coin_risk_summary` | Table | MARTS | Cortex AI risk assessment |
| `hub_coin` | Table | VAULT | Data Vault - coin entity |
| `hub_currency` | Table | VAULT | Data Vault - currency entity |
| `link_coin_currency` | Table | VAULT | Data Vault - coin-currency relationship |
| `sat_coin_market_data` | Incremental | VAULT | Data Vault - historical market data |

### Data Vault 2.0
- **Hub** — business keys (coin_id, currency_code)
- **Link** — relationships between entities (coin x currency)
- **Satellite** — historical attributes with load_date

### dbt Tests
- **Generic** — `unique`, `not_null` on key columns
- **Singular** — business logic (positive prices, non-negative volume, positive market cap rank)

## Setup

### Prerequisites
- Python 3.13+
- Snowflake account
- dbt 1.11+

### Installation
```bash
# Clone repo
git clone https://github.com/your-username/crypto-dbt-pipeline.git
cd crypto-dbt-pipeline

# Create virtual environment
python -m venv .venv
.venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### Environment Variables

Create `.env` file:
```
SNOWFLAKE_USER=your_user
SNOWFLAKE_PASSWORD=your_password
SNOWFLAKE_ACCOUNT=your_account
SNOWFLAKE_WAREHOUSE=CRYPTO_WH
SNOWFLAKE_DATABASE=CRYPTO_DB
SNOWFLAKE_ROLE=CRYPTO_DBT
```

### Run Pipeline
```bash
# Ingest data from CoinGecko
python -m ingestion.main

# Run dbt transformations
cd dbt_crypto
dbt seed
dbt run
dbt test
dbt docs generate && dbt docs serve
```

## Data Quality

9 tests covering:
- Unique coin identifiers
- Non-null critical fields
- Positive prices and volumes
- Valid market cap ranks

## Notes

- CoinGecko free tier — rate limits handled with `time.sleep(5)`
- MAX_PAGES = 2 to avoid rate limiting (500 coins)
- Cortex AI limited to `limit 10` to manage compute costs
- Zero-Copy Clone (`CRYPTO_DB_DEV`) for safe development

## Author

Adam — Data Engineer candidate