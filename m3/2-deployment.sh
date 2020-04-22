cd ~/kvm/k8s/lab-k8s/m3

# Demo 2.1 - Updating to a non-existent image.
# Delete any current deployments, because we're interest in the deploy state changes.
kubectl delete deployment hello-world
kubectl delete service hello-world

# Create our v1 deployment, then update it to v2
kubectl apply -f deployment-v1.yaml
kubectl apply -f deployment-v2.yaml

# Observe behavior since new image wasn't available, the ReplicaSet doesn't go below maxUnavailable
kubectl apply -f deployment-broken.yaml

# Why isn't this finishing...? after progressDeadlineSeconds which we set to 10 seconds (defaults to 10 minutes)
kubectl rollout status deployment hello-world

# Expect a return code of 1 from kubectl rollout status... that's how we know we're in the failed status.
echo $?


# Let's check out Pods, ImagePull/ErrImagePull... ah an error in our image definition.
# Also, it stopped the rollout at 5, that's kind of nice isn't it?
# And 8 are online, let's look at why.
kubectl get pods


# What is maxUnavailable? 25%...So only two Pods in the ORIGINAL Replicaset are offline and 8 are online.
# What is maxSurge? 25%? So we have 13 total Pods, or 25% in addition to Desired number.
# Look at Replicas and OldReplicaSet 8/8 and NewReplicaSet 5/5.
# Available	True	MinimumReplicasAvailable
# Progressing	False	ProgressDeadlineExceeded
kubectl describe deployments hello-world

# Let's sort this out now...check the rollout history, but which revision should we rollback to?
kubectl rollout history deployment hello-world

# It's easy in this example, but could be harder for complex sytems.
# Let's look at our revision Annotation, should be 3
kubectl describe deployments hello-world | head

# We can also look at the changes applied in each revision to see the new pod templates
kubectl rollout history deployment hello-world --revision=2
kubectl rollout history deployment hello-world --revision=3

# Let's undo our rollout to revision 2, which is our v2 conainter.
kubectl rollout undo deployment hello-world --to-revion=2
kubectl rollout status deployment hello-world
echo $?

# Let's delete this Deployment and start over with a new Deployment.
kubectl delete deployment hello-world
kubectl delete service hello-world





### Examine deployment-probes-1.yaml, review strategy settings, revision history, and readinessProbe settings

## QUICKLY run these two commands or as one block. ##
# Demo 3 - Controlling the rate and update strategy of a Deployment update
# Let's deploy a Deployment with Readiness Probes
kubectl apply -f deployment-probes-1.yaml --record

# Available is still 0 because of our Readiness Probe's initialDelaySeconds is 10 seconds.
# Also, look there's a new annotation for our change-cause
# And check the Conditions,
# Progressing	True	NewReplicaSetCreated or ReplicaSetUpdated - depending on the state.
# Available	False	MinimumReplicasUnavailable
kubectl describe deployment hello-world
######################################################

#Check again, Replicas and Conditions, all Pods should be online and ready.
# Available	True	MinimumReplicasAvailabl
# Progressing	True	NewReplicaSetAvailable
