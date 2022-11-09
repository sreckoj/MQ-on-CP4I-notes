
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






