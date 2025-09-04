import json, requests, os
from requests.exceptions import RequestException
class KafkaConnectClient:

    def __init__(self):
        self.connect_url = os.getenv('CONNECT_URL')
        self.NEW_CONNECTOR_PATH = f"{self.connect_url}/connectors/"
        self.HEADERS = {
            'Content-type': 'application/json'
        }

    def post_new_connector(self, logger, connector_config):
        logger.debug(connector_config)
        logger.debug(f"{self.NEW_CONNECTOR_PATH }")
        connector_config = self.connector_config_auth_set(connector_config)
        response = requests.post(
            self.NEW_CONNECTOR_PATH,
            json=connector_config,
            headers=self.HEADERS
        )
        if response.status_code == 400:
            logger.error(response.json())
            raise RequestException
        
    def connector_config_auth_set(config):
        config['config']['confluent.topic.sasl.jaas.config'] = f"org.apache.kafka.common.security.plain.PlainLoginModule required username=\"{os.getenv('CCLOUD_API_KEY')}\" password=\"{os.getenv('CCLOUD_API_SECRET')}\";"
        config['config']['schema.history.internal.consumer.sasl.jaas.config'] = f"org.apache.kafka.common.security.plain.PlainLoginModule required username=\"{os.getenv('CCLOUD_API_KEY')}\" password=\"{os.getenv('CCLOUD_API_SECRET')}\";"
        config['config']['schema.history.internal.producer.sasl.jaas.config'] = f"org.apache.kafka.common.security.plain.PlainLoginModule required username=\"{os.getenv('CCLOUD_API_KEY')}\" password=\"{os.getenv('CCLOUD_API_SECRET')}\";"
        return config