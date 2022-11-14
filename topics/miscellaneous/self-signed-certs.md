
# Working with the self-signed certificates

There are several situations when we need to create self-signed certificates and store them in different key/certificate file formats. Here are some useful commands.

## Create certificates with the OpenSSL tool

Let's assume that we need two key/certificate pairs. One for the server and the other for the client.

Create a certificate for the server:
```
openssl req -newkey rsa:2048 -nodes -keyout server.key -x509 -days 365 -out server.crt
```

Create a certificate for the client:
```
openssl req -newkey rsa:2048 -nodes -keyout client.key -x509 -days 365 -out client.crt
```

Result:
```
client.crt  - client's public certificate
client.key  - client's private key
server.crt  - server's public certificate 
server.key  - server's private key
```

## Create the PKCS12 (.p12) file

Create a pkcs12 file from the certificate and the key:
```
openssl pkcs12 -export -in client.crt -inkey client.key -out client.p12 -name "client pkcs12"
```
Enter the password when prompted, for example, *passw0rd*

Verify with Keytool (we assume here that the previously defined password is *passw0rd*):
```
keytool -list -v -keystore client.p12 -storepass passw0rd
```

View the certificate:
```
openssl pkcs12 -info -in client.p12
```

View the private key:
```
openssl pkcs12 -in client.p12 -nocerts -nodes
```

## Create a key database file (KDB):

We can use *runmqakm* and *runmqckm* MQ tools to work with the KDB files. We don't need to install the MQ server or client on our workstation. Instead, we can run MQ in a container and mount our working directory as a volume in the container (we can use the same trick also for the other MQ tools and sample applications - of course, we need Docker to be installed on our computer).

Run MQ in container (we assume here that our working directory is */root/tutorials/ssl* and it is mounted to the directory */mnt/certs* inside the container, we also assume that the contaner name is *mymq*): 
```
docker run --name mymq --rm -e LICENSE=accept --volume /root/tutorials/ssl:/mnt/certs --detach ibmcom/mq:latest
```

Enter "into" the container (we assume here the container name *mymq*, we can use also the GUID instead of the name:
```
docker exec -it mymq \bin\bash
```


Navigate to the directory inside the container:
```
cd /mnt/certs/
```

Create kdb file (the filename is *mq-secure.kdb* and the password is *passw0rd*):
```
runmqakm -keydb -create -db mq-secure.kdb -pw passw0rd -type cms -expire 1000 -stash
```

Import server's public certificate into kdb, label it *mqserver*:
```
runmqakm -cert -add -label mqserver -db mq-secure.kdb -pw passw0rd -trust enable -file server.crt
```

Import the client's p12 file into the client key database and label it *clientapp*
```
runmqckm -cert -import -file client.p12 -pw passw0rd -type pkcs12 -target mq-secure.kdb -target_pw passw0rd -target_type cms -label "client pkcs12" -new_label clientapp
```

View the content of the kdb:
```
runmqakm -cert -list all -db mq-secure.kdb -stashed
runmqakm -cert -details -db mq-secure.kdb -stashed -label mqserver
runmqakm -cert -details -db mq-secure.kdb -stashed -label clientapp
```

We can now provide the followning files to the client:
```
mq-secure.kdb
mq-secure.sth   # contains password
```






























