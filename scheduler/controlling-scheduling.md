# Controling Scheduling

- Node Selector
- Affinity
- Taint and Tolerations
- Node Cordoning
- Manual Scheduling


## Node Selector

- nodeSelector - assign Pods to Nodes using Labels and Selectors
- Apply Labels to Nodes
- Scheduler will assign Pods a to a Node with a matching Label
- Simple key/value check based on *matchLabels*
- Often used to map Pods to Nodes based on ...
  - Special hardware requirements
  - Workload isolation


Assigning Pods to Nodes using Node Selectors

```
kubectl label node node01.hl.local hardware=local_gpu

spec:
  containers:
  - name: hello-world
    image: gcr.io/google-sample/hello-app:1.0
    ports:
    - containerPort: 8080
  nodeSelector:
    hardware: local_gpu
```

## Affinity and Anti-Affinity

- *nodeAffinity* - uses Labels on Nodes to make a scheduling decision with *matchExpressions*

- requiredDuringSchelingIgnoredDuringExecution
- preferreddDuringSchelingIgnoredDuringExecution

- *podAffinity* - schedule Pods onto the same Node, Zone as some other Pod
- *podAntiAffinity* - schedule Pods onto the different Node, Zone as some other Pod


Using Affinity to Control Pod Placement

```
spec:
  containers:
  - name: hello-world-cache
  ...
  affinity:
    podAffinity:
      requiredDugingSchedulingIgnoredDuringExecution:
      - labelSelector:
	  matchExpressions:
	  - key: app
	    operator: In
	    values:
	    - hello-world-web
        topologyKey: "kubernetes.io/hostname"
```

## Taints and Tolerations

- Taints - ability to control which Pods are scheduled to Nodes
- Tolerations - allows a Pod to ignore a Taint and be scheduled as normal on Tainted Nodes

Useful in scenarios where the cluster administrator needs to influence scheduling without depeding on the user
 
```
key=value:effect

kubectl taint nodes node01.hl.local key=MyTaint:NoSchedule

spec:
  containers:
  - name: hello-world
    image: gcr.io/google-samples/hello-app:1.0
    ports:
    - containerPort: 8080
  tolerations:
  - key: "key"
    operator: "Equal"
    value: "MyTaint"
    effect: "NoSchedule"
```
