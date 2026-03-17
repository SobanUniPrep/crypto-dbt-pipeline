import requests
import logging
import time
from ingestion import config

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
        all_coins.extend(coins)
        if len(coins) < config.PER_PAGE or page >= config.MAX_PAGES:
            break
        page += 1
        time.sleep(5)
    logger.info(f"Total coins extracted: {len(all_coins)}")
    return all_coins

if __name__ == "__main__":
    coins = extract_all_coins()
    logger.info(f"Sample: {coins[0]}")