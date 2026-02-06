NAME=jnrosale-desktop # Change this to your cruzid
POD_NAME=jnrosale-carla # Change this to your cruzid
CACHE_NAME=jnrosale-carla-cache # Change this to your cruzid
NAMESPACE=aiea-auditors

if [ "$1" -eq 1 ]; then
    kubectl delete deployment $NAME -n $NAMESPACE
    kubectl delete service $NAME -n $NAMESPACE
    kubectl delete ingress $NAME -n $NAMESPACE
elif [ "$1" -eq 0 ]; then
    kubectl create -f storage.yml -n $NAMESPACE
    kubectl create -f cache.yml -n $NAMESPACE
    kubectl create -f desktop.yml -n $NAMESPACE
    kubectl create -f desktop-ingress.yml -n $NAMESPACE
elif [ "$1" -eq 2 ]; then
    kubectl delete deployment $NAME -n $NAMESPACE
    kubectl delete service $NAME -n $NAMESPACE
    kubectl delete ingress $NAME -n $NAMESPACE
    kubectl delete pvc --now $POD_NAME -n $NAMESPACE
    kubectl delete pvc --now $CACHE_NAME -n $NAMESPACE
else
    echo "Usage: $0 [1]"
    exit 1
fi