
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































