package admission

import data.k8s.matches

# we cannot have more than 500 total cpu core for the myrepo/myimage workload

deny[{
	"id": "loadbalancer-service-quota",
	"resource": {"kind": "pods", "namespace": namespace, "name": name},
	"resolution": {"message": "we cannot have more than 500 total cpu core for the myrepo/myimage workload"},
}] {
    matches[["services", any_namespace, any_name, matched_pods]]
    containers := ??
    sum (regexpr ("get the number",containers.resources.request.cpu)) < 500 * 1000
}