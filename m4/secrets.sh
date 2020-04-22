# Demo 1 - Creating and accessing Secrets
# Generic - Create a secret from a local file, directory or literal value
# They keys and values are case sensitive

kubectl create secret generic app1 \
  --from-literal=USERNAME=app1login \
  --from-literal=PASSWORD='S0methingS@Str0ng!'

# Opaque means it's an arbitrary user defined key/value pair. Data 2 means two/value pairs in the secret;
# Other types include service accounts and container registry authentication info
kubectl get secrets

#app1 said it had 2 Data elements, let's look
kubectl describe secret app1

# If we need to access those at the command line ...
# These are wrapped in bash expansion to add to output for readability
echo $(kubectl get secret app1 --template={{.data.USERNAME}} )
echo $(kubectl get secret app1 --template={{.data.USERNAME}} | base64 --decode )

echo $(kubectl get secret app1 --template={{.data.PASSWORD}} )
echo $(kubectl get secret app1 --template={{.data.PASSWORD}} | base64 --decode )





# Demo 2 - Accessing Secrets inside a Pod
# As environment variables
kubectl apply -f deployment-secrets-env.yaml

PODNAME=$(kubectl get pods | grep hello-world-secrets-env | awk '{print $1}' | head -n 1)
echo $PODNAME

# Now let's get our enviroment variables from our container
# Our Environment variables form our Pod Spec are defined
kubectl exec -it $PODNAME -- /bin/sh
printenv | grep ^app1
exit
