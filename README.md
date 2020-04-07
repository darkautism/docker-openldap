# openldap

Old openldap support monitor database base on centos 6.

Here is an example for k8s, please set your pvc and set your ip befor apply this config

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: ldap
  name: ldap-deployment
spec:
  selector:
    matchLabels:
      app: ldap
  template:
    metadata:
      labels:
        app: ldap
    spec:
      containers:
      - name: ldap
        image: darkautism/openldap
        ports:
        - containerPort: 389
          protocol: TCP
          name: ldap-port
        - containerPort: 389
          protocol: UDP
          name: ms-ldap-port
        - containerPort: 639
          protocol: TCP
          name: tls-ldap-port
        volumeMounts:
          - name: nfs
            mountPath: /etc/openldap
            subPath: openldap
          - name: nfs
            mountPath: /var/lib/ldap
            subPath: ldap
      volumes:
      - name: nfs
        persistentVolumeClaim:
          claimName: ldap-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: ldap-service
  namespace: ldap
  annotations:
    metallb.universe.tf/allow-shared-ip: external-dns
spec:
  externalIPs:
  - IPUWant
  ports:
  - port: 389
    protocol: TCP
    targetPort: 389
    name: ldap-port
  - port: 639
    protocol: TCP
    targetPort: 639
    name: tls-ldap-port
  selector:
    app: ldap
  sessionAffinity: None
  type: LoadBalancer
---
apiVersion: v1
kind: Service
metadata:
  name: ldap-service-udp
  namespace: ldap
  annotations:
    metallb.universe.tf/allow-shared-ip: external-dns
spec:
  externalIPs:
  - IPUWant
  ports:
  - port: 389
    protocol: UDP
    targetPort: 389
    name: ms-ldap-port
  selector:
    app: ldap
  sessionAffinity: None
  type: LoadBalancer

```
