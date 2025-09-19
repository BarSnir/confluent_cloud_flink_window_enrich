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
    if PROCESS_STEP == "step_a":
        setup_database.process(logger)
        process_batch_dataset.process(logger, "process_list_full")
        process_debezium.process(logger)
    elif PROCESS_STEP == "step_b":
        process_elasticsearch_connector.process(logger)
        process_elasticsearch_connector.process(logger, create_dims=True)
        process_s3_connector.process(logger)
        process_neo4j_connector.process(logger)
    elif PROCESS_STEP == "step_c":
        process_batch_dataset.process(logger, "process_list_orders_generator")

if __name__ == "__main__":
    main()