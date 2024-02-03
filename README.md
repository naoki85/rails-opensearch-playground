# Rails Opensearch Playground

## Start and stop containers

```
$ docker-compose up -d
```

```
$ docker-compose down
```

## Create a new index and mappings

[https://opensearch.org/docs/latest/clients/ruby/#creating-an-index](https://opensearch.org/docs/latest/clients/ruby/#creating-an-index)

```rb
client = OpenSearch::Client.new(
  url: OPENSEARCH_URL,
  retry_on_failure: 5,
  request_timeout: 120,
  log: true
)

index_body = {
  'settings': {
      'index': {
      'number_of_shards': 1,
      'number_of_replicas': 0
      }
  }
} 

client.indices.create(
    index: 'students',
    body: index_body
)
client.indices.put_mapping(
    index: 'students', 
    body: {
        dynamic: 'strict',
        properties: {
            first_name: { type: 'keyword' },
            last_name: { type: 'keyword' },
            grade: { type: 'integer'},
            created: { type: 'date'}
        }  
    }
)
```
