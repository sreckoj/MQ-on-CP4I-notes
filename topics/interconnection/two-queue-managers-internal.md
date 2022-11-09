
# Connectivity between two queue managers <br> on the same OpenShift cluster

>Note: Especially interesting is the requirement that the connection is secured using **mTLS**. We will focus on that.

Assumptions:
  - Queue managers names: **QMA**, **QMB**
  - Both queue managers in the same namespace: **mq**


## Create certificates

For demo purposes, we will create self-signed certificates.

Create a certificate for QMA:
```
openssl req -newkey rsa:2048 -nodes -keyout qma.key -x509 -days 365 -out qma.crt
```

When asked, enter the certificate details, for example:
```
Country Name (2 letter code) []:DE
State or Province Name (full name) []:.
Locality Name (eg, city) []:.
Organization Name (eg, company) []:ACME
Organizational Unit Name (eg, section) []:Test
Common Name (eg, fully qualified host name) []:test.acme.com
Email Address []:test.user@acme.com
```

Repeat the same for QMB:
```
openssl req -newkey rsa:2048 -nodes -keyout qmb.key -x509 -days 365 -out qmb.crt
```

Enter details:
```
Country Name (2 letter code) []:DE
State or Province Name (full name) []:.
Locality Name (eg, city) []:.
Organization Name (eg, company) []:ACME
Organizational Unit Name (eg, section) []:Test
Common Name (eg, fully qualified host name) []:test.acme.com
Email Address []:test.user@acme.com
```

As a result, we have the following files:
```
qma.crt
qma.key
qmb.crt
qmb.key    
```

## Create secrets

The easiest way is to do this in OpenShift web console. Select **Workloads > Secrets** on the navigation panel and then select the project, in our case it is **mq**. Click on the button **Create** and select **Key/value secret**. 

- Enter the secret name: **qma-tls** <br>
  and add two key/value pairs:
  - Key: *tls.key* <br>
    Value: drag & drop the file *qma.key*
  - Key: *tls.crt* <br>
    Value: drag and drop *qma.crt*

































