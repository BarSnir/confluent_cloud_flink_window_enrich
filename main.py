from libs.utils.logger import ColorLogger
from steps import (
    setup_database,
    process_batch_dataset,
    process_debezium,
    process_elasticsearch_connector,
    process_s3_connector,
    process_neo4j_connector
)
import os


def main():
    PROCESS_STEP = os.getenv("PROCESS_STEP", "")
    logger = ColorLogger("event_driven_freedom").get_logger()
    # your app logic:
    if PROCESS_STEP == "load_dataset":
        setup_database.process(logger)
        process_batch_dataset.process(logger, "process_list_full")
    if PROCESS_STEP == "generate_orders":
        process_batch_dataset.process(logger, "process_list_orders_generator")
    elif PROCESS_STEP == "create_debezium":
        process_debezium.process(logger)
    elif PROCESS_STEP == "create_target_connectors":
        process_elasticsearch_connector.process(logger)
        process_s3_connector.process(logger)
        process_neo4j_connector.process(logger)

if __name__ == "__main__":
    main()
