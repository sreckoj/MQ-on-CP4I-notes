
# Working with the self-signed certificates

There are several situations when we need to create self-signed certificates and store them in different key/certificate file formats. Here are some useful commands.

## Create certificates with openssl tool

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

