import logging
from ingestion.extract import extract_all_coins
from ingestion.load import load_coins

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

def main():
    logger.info("Starting crypto ingestion pipeline")
    coins = extract_all_coins()
    load_coins(coins)
    logger.info("Pipeline completed successfully")

if __name__ == "__main__":
    main()