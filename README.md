# faas-grafana

First build your image 

```
docker build -t faas-grafana:v1 grafana/.
```

### Kubernetes

Run Grafana in OpenFaaS Kubernetes namespace. Make sure you have set you minio docker env:

```bash
kubectl -n openfaas run \
--image=faas-grafana:v1 \
--port=3000 \
grafana
```

Expose Grafan with a NodePort:

```bash
kubectl -n openfaas expose deployment grafana \
--type=NodePort \
--name=grafana
```

Forward localhost to Grafana:
```
kubectl port-forward pod/grafana 3000:3000 -n openfaas
```
kubectl port-forward pod/grafana 3000:3000 -n openfaas

URL: `http://localhost:3000/dashboard/db/openfaas`
Credentials: `admin/admin`