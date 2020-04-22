cd ~/kvm/k8s/lab-k8s/m3

# Demo 1 - Updating a Deployment and checking our rollout status
# Let's start off with rolling out v1
kubectl apply -f deployment.yaml

#Check the status of the deployment
kubectl get deployment hello-world

# Let's check the status of that rollout, while the command blocking your deployment is in the Progressing status.
kubectl rollout status deployment hello-world

# Let's walk through the description of the deployment ...
# Check out Replicas, Conditions and Events OldReplicaSet (will only be populated during a rollout) and NewReplicaSet
# Conditions (more information about our objects state):
#	Available 	True	MinimumReplicasAvailable
#	Progressing	True	NewReplicaSetAvailable (when true, deployment is still progressing or complete)
kubectl describe deployments hello-world

#Both replicasets remain, and that will become very useful shortly when we use a rollback :)
kubectl get replicaset
