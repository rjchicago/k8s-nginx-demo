# nginx-demo

Run a local K3s cluster via `K3D`:

``` sh
# k3d cluster
sh k3d/start.sh
```

## helm install

``` sh
# helm install
helm install nginx-demo ./helm

# open browser
open http://localhost:8080
```

## kubectl apply

manually deploy via custom scripts and `kubectl apply`

``` sh
# deploy demo
CONTEXT=k3d-local sh scripts/deploy.sh

# open browser
open http://localhost:8080
```
