start: stop
	docker-compose up -d &

stop:
	docker-compose down

deploy:
	curl -X PUT -H "Content-Type: application/json" --data @connectors/source-pageviews.json http://localhost:8083/connectors/source-pageviews/config
	curl -X PUT -H "Content-Type: application/json" --data @connectors/sink-pageviews-daily.json http://localhost:8083/connectors/sink-pageviews-daily/config
	curl -X PUT -H "Content-Type: application/json" --data @connectors/sink-pageviews-default.json http://localhost:8083/connectors/sink-pageviews-default/config

read-topic:
	docker-compose exec connect kafka-console-consumer --topic pageviews --bootstrap-server kafka:29092  --property print.key=true --max-messages 5 --from-beginning

minio-ui:
	open http://127.0.0.1:9001/