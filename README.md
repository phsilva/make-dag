
# Make DAG visualization

make is a build tool create in 1977. It is well known and can be used anywhere you need depencied management.

Here is an example of using make a DAG scheduler. A Directed Acyclic Graph (DAG) is usually used to model sequence of dependent tasks.

The idea and code here came from the excelent article of Alex Dean at Snowplow blog http://snowplowanalytics.com/blog/2015/10/13/orchestrating-batch-processing-pipelines-with-cron-and-make/, just compiled it here to help my memory.

```make
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
```

To visualize this as a DAG, use makefile2dot.py which reads make targets and create a Graphviz visualization.

```sh
python makefile2dot.py < Makefile | dot -Tpdf > process.pdf
open process.pdf
```

![make DAG](https://github.com/phsilva/make-dag/blob/master/process.png)
