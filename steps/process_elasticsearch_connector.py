from requests.exceptions import RequestException
from libs.utils.list import ListUtils
from libs.utils.files import FileUtils
from libs.utils.logger import ColorLogger
from libs.connectors.kafka_connect import KafkaConnectClient
from libs.connectors.kafka_admin import KafkaAdminClientWrap
from libs.connectors.elasticsearch import ElasticsearchConnector

MODULE_MESSAGE = 'Step F || Generating Elasticsearch sink connector'
FILE_PATH = '/opt/flink/project/configs/elasticsearch.json'
INDEX_PATTERN = '/opt/flink/project/configs/index_pattern.json'
DIMS_PATTERNS = '/opt/flink/project/configs/indices_patterns.json'
DIMS_PATH = '/opt/flink/project/configs/elasticsearch_dims.json'

def process(logger, create_dims=False):
    ColorLogger.log_new_step_dashes(logger)
    logger.info(MODULE_MESSAGE)
    ColorLogger.log_new_step_dashes(logger)
    kafka_admin_client = KafkaAdminClientWrap(logger)
    kafka_connect_client = KafkaConnectClient()
    elasticsearch_connector = ElasticsearchConnector()
    try:
        put_indices_pattern(
            elasticsearch_connector,
            logger, 
            create_dims
        )
        config = get_config(logger, create_dims)
        logger.debug(config)
        topic_list = ListUtils.str_to_list(
            config.get('config').get('topics'),
            special_erases=['production.']
        )
        logger.debug(topic_list)
        kafka_admin_client.find_topics(topic_list)
        kafka_connect_client.post_new_connector(
            logger, config
        )
        logger.info(f"Done!")
    except RequestException:
        logger.error("Pay attention to connector request.")
    except Exception as e:
        logger.error(e)

def put_indices_pattern(elasticsearch_connector, logger, create_dims=False):
    if create_dims:
        index_pattern = FileUtils.get_json_file(DIMS_PATTERNS)
        elasticsearch_connector.put_index_pattern(index_pattern, logger)
        return
    index_pattern = FileUtils.get_json_file(INDEX_PATTERN)
    elasticsearch_connector.put_index_pattern(index_pattern, logger)

def get_config(logger, create_dims=False):
    if create_dims:
        logger.info("Creating dims connector")
        return FileUtils.get_json_file(DIMS_PATH)
    return FileUtils.get_json_file(FILE_PATH)