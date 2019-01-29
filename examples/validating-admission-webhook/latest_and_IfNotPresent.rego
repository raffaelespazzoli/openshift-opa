package admission

import data.k8s.matches

# Common function to validate containers
validate_containers(containers) {
    containers.imagePullPolicy
    containers.imagePullPolicy = "IfNotPresent"
    endswith(containers.image,":latest")
}

deny[{
	"id": "pods-imagepullpolicy-latest",
	"resource": {"kind": "pods", "namespace": namespace, "name": name},
	"resolution": {"message": "image pull policy and image tag cannot be repectively IfNotPresent and latest at the same time"},
}] {
    matches[["pods", namespace, name, matched_workload]]
    containers := matched_workload.object.spec.containers[_]

	validate_containers(containers)
}

#deny[{
#    "type": "always pull latest",
#    "resource": {"kind": "cronjobs", "namespace": namespace, "name": name},
#    "resolution": {"message": "image pull policy and image tag cannot be repectively IfNotPresent and latest at the same time"},
#}]{
#    matches[["cronjobs", namespace, name, matched_workload]]
#    container = matched_workload.spec.jobTemplate.spec.template.spec.containers[_]
#    container.imagePullPolicy = "IfNotPresent"
#    endswith(container.image,":latest")
#}

#deny[{
#    "type": "always download latest",
#    "resource": {"kind": kind, "namespace": namespace, "name": name},
#    "resolution": {"message": "image pull policy and image tag cannot be repectively IfNotPresent and latest at the same time"},
#}]{
#    matches[[kind, namespace, name, matched_workload]]
#    re_match("^(Deployment|ReplicaSet|ReplicationController|StatefulSet|DaemonSet|Job)$", kind)
#    container = matched_workload.spec.template.spec.containers[_]
#    container.imagePullPolicy = "IfNotPresent"
#    endswith(container.image,":latest")
#}