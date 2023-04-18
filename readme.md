
# Description
This project tries to show the different ways [Confluent S3SinkConnector](https://docs.confluent.io/kafka-connectors/s3-sink/current/overview.html) can store objects in S3 depending on it's configuration. We will use docker compose to create the infrastructure needed to run the examples. In this execise AWS S3 object storage will be replaced by a local [minio](https://min.io/) server so we can run all the infrastructure locally.

When all three provided connectors are deployed, a stream of "pageview" events are stored in S3.


```
                                                                                 +-------------------+
                                                                                 |       minio       |
                                                                                 |                   |
                                                    +---------------------+      | +---------------+ |
                                                    |                     |      | |/partition=3   | |
                                                    | DefaultPartitioner  |      | |               | |
                                              +---->| S3 Sink Connector   +------+>|               | |
                                              |     |                     |      | +---------------+ |
+--------------------+     +-------------+    |     +---------------------+      |                   |
|                    |     |             +----+                                  |                   |
|  Pageviews         +---->|  pageviews  |                                       |                   |
|  DatagenConnector  |     |  topic      |          +---------------------+      | +---------------+ |
|                    |     |             +----+     |                     +------+>|/year=2023/... | |
+--------------------+     +-------------+    |     | DailyPartitioner    |      | |               | |
                                              +---->| S3 Sink Connector   |      | |               | |
                                                    |                     |      | +---------------+ |
                                                    +---------------------+      |                   |
                                                                                 +-------------------+
```

# Run project
## Run infra
```shell
make start
```
## Deploy connectors
```shell
make start
```
## Open minio web console
```shell
make minio-ui
```

# Objects distribution
Depending on the partitioner we choose (there are two different examples in the repo) connector will create a different folder structure inside S3
## default partitioner
will create the different objects in a tree structure like this
`somebucketname/topics/pageviews/partition=0`
## time based partitioners
for example, daily partitioner will create the different objects in a tree structure like this
`somebucketname/topics/pageviews/year=2023/month=04/day=18`