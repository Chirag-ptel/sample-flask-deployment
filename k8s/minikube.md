## Run MINIKUBE locally

#### To start the minikube cluster use the below command

```bash
minikube start --cpus=2 memory=2048 --driver=docker --nodes=1
```
#### Apply the manifest using kubectl apply

```bash
kubectl apply -f /path/to/deployment.yaml
kubectl apply -f /path/to/service/yaml
```
#### To get the serice endpoint use the below command

```bash
minikube service <service-name> --url
```
This will return the url like `http://127.0.0.1:52105` keep the terminal running and browse this url.

#### If using VirtulBox as a driver for minikube the below method can be used to access the NodePort service, It doesn't work with docker driver cause minikube runs inside a docker container which has its own private network hence `minikube ip` is no reachable from your host machine therefore use the above method with `minikube service`.

```bash
minikube ip
```
This will return the ip like `192.168.49.2`.
This ip can be used for accessing the nodeport service like below
http://<minikube-ip>:<nodeport>