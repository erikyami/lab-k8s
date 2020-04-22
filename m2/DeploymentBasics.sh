# Demo 1 - Creating a Deployment
# Demo 1.a - Imperatively, with kubectl run, you have lot's of options available to you
# such as resource limits, restart policies, or events starting other workload types such as Jobs and bare POds.
kubectl create deployment hello-world --image=gcr.io/google-samples/hello-app:1.0

kubectl scale deployment hello-world --replicas=5

kubectl get all

kubectl delete deployments.apps hello-world
