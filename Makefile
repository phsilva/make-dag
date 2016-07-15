done: send-completed-sns

send-starting-sns:
	echo "Sending SNS for job starting" && sleep 5
snowplow-emr-etl-runner: send-starting-sns
	echo "Running Snowplow EmrEtlRunner" && sleep 5
snowplow-storage-loader: snowplow-emr-etl-runner
	echo "Running Snowplow StorageLoader" && sleep 5
huskimo: send-starting-sns
	echo "Running Huskimo" && sleep 2
sql-runner: snowplow-storage-loader huskimo
	echo "Running data models" && sleep 5
send-completed-sns: sql-runner
	echo "Sending SNS for job completion" && sleep 2
