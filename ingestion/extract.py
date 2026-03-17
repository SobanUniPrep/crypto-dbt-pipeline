import requests
import logging
from ingestion import config

# Logging setup
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

def fetch_coins(page: int, per_page: int, vs_currency: str) -> list:
    url = f"{config.API_BASE_URL}/coins/markets"
    params = {
        "vs_currency": vs_currency,
        "per_page": per_page,
        "page": page
    }
    response = requests.get(url, params=params)
    response.raise_for_status()
    return response.json()

def extract_all_coins() -> list:
    all_coins = []
    page = 1
    while True:
        logger.info(f"Fetching page {page}")
        coins = fetch_coins(page, config.PER_PAGE, config.VS_CURRENCY)
        if len(coins) < config.PER_PAGE:
            all_coins.extend(coins)
            break
        all_coins.extend(coins)
        page += 1
    logger.info(f"Total coins extracted: {len(all_coins)}")
    return all_coins

if __name__ == "__main__":
    coins = extract_all_coins()
    logger.info(f"Sample: {coins[0]}")