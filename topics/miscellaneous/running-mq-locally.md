
# Running MQ locally - in a container

There are several situations when we would like to test MQ running in the OpenShift cluster from our local developer machine using out-of-the-box test programs like *amqsputc* or *amqsgetc*, and other MQ utilities. In order to do that we need an MQ client or server installed on the machine. The quick way to achieve that is to run MQ locally in a container. We, of course, need Docker or Podman installed on our machine. 

The important detail is defining the container volume where we map our local directory with needed artifacts to the directory inside the container.

Let's assume that our local working directory is */root/mq_test* (we are using Linux here, but the equivalent steps can be done also on Windows).

Run the container:
```
docker run --name mymq --rm -e LICENSE=accept --volume /root/mq_test:/mnt/test --detach ibmcom/mq:latest
```

Enter "into" the container:
```
docker exec -it mymq \bin\bash
```

Navigate to the directory with the artifacts:
```
cd /mnt/test/
```


