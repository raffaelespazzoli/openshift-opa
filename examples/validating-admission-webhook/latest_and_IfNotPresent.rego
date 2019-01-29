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