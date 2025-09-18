import json, argparse 

def generate_env_file(org_id):
    with open("./terraform/secrets.json", "r") as secrets_file:
        secrets = json.loads(secrets_file.read())
        with open(".env", "w") as env_file:
            env_file.write(f"CCLOUD_BROKER_HOST={get_broker_host(secrets)}\n")
            env_file.write(f"CCLOUD_API_KEY={fetch_secret_value(secrets, 'connectors_api_key')}\n")
            env_file.write(f"CCLOUD_API_SECRET={fetch_secret_value(secrets, 'connectors_api_secret')}\n")
            env_file.write(f"CCLOUD_SCHEMA_REGISTRY_URL={fetch_secret_value(secrets, 'schema_registry_rest_endpoint')}\n")
            env_file.write(f"CCLOUD_SCHEMA_REGISTRY_API_KEY={fetch_secret_value(secrets, 'schema_registry_api_key')}\n")
            env_file.write(f"CCLOUD_SCHEMA_REGISTRY_API_SECRET={fetch_secret_value(secrets, 'schema_registry_api_secret')}\n")
            env_file.write(f"CCLOUD_MONITORING_API_KEY_ID={fetch_secret_value(secrets, 'monitoring_api_key_id')}\n")
            env_file.write(f"CCLOUD_MONITORING_API_KEY_SECRET={fetch_secret_value(secrets, 'monitoring_api_key_secret')}\n")
            env_file.write(f"CCLOUD_API_FLINK_SECRET={fetch_secret_value(secrets, 'flink_api_secret')}\n")
            env_file.write(f"CCLOUD_COMPUTE_POOL_IDS={fetch_secret_value(secrets, 'flink_compute_pool_id')}\n")
            env_file.write(f"CONFLUENT_ENVIRONMENT_ID={fetch_secret_value(secrets, 'environment_id')}")
            print("Before Running the next terraform stage, pase this in your terminal:")
            terminal_message = rf"""
export CCLOUD_BROKER_HOST={get_broker_host(secrets)} \
FLINK_COMPUTE_POOL_ID={fetch_secret_value(secrets, 'flink_compute_pool_id')} \
FLINK_API_KEY={fetch_secret_value(secrets, 'flink_api_key')} \
FLINK_API_SECRET={fetch_secret_value(secrets, 'flink_api_secret')} \
FLINK_PRINCIPAL_ID={fetch_secret_value(secrets, 'flink_service_account_id')} \
FLINK_REST_ENDPOINT={fetch_secret_value(secrets, 'flink_rest_endpoint')} \
CONFLUENT_ENVIRONMENT_ID={fetch_secret_value(secrets, 'environment_id')} \
CONFLUENT_ORGANIZATION_ID={org_id}    
            """
            print(terminal_message)
            return secrets

def generate_prometheus_yaml(secrets):
    with open("./prometheus/prometheus.template.yml", "r") as prometheus_file:
        prometheus_content = prometheus_file.read()
        with open("./prometheus/prometheus.yml", "w") as new_prometheus_file:
            new_prometheus_file.write(
                prometheus_content \
                .replace("xxCCLOUD_MONITORING_API_KEY_ID", f"{fetch_secret_value(secrets, 'monitoring_api_key_id')}") \
                .replace("xxCCLOUD_MONITORING_API_KEY_SECRET", f"{fetch_secret_value(secrets, 'monitoring_api_key_secret')}") \
                .replace("xxCCLOUD_COMPUTE_POOL_IDS", f"{fetch_secret_value(secrets, 'flink_compute_pool_id')}")
            )

def fetch_secret_value(secrets, key):
    return secrets.get(key).get('value')

def get_broker_host(secrets):
    kafka_bootstrap_endpoint = secrets.get('kafka_bootstrap_endpoint').get('value')
    return kafka_bootstrap_endpoint \
        .replace(":9092", "") \
        .replace("SASL_SSL://", "")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Optional app description')
    parser.add_argument('org_id', type=str, help='Required generator.')
    args = parser.parse_args()
    if not args.org_id:
        raise ValueError("org_id is required")
    secrets = generate_env_file(args.org_id)
    generate_prometheus_yaml(secrets)