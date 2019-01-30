# normal namespoaces are allowed to create only 2 loadbalancer type services
package admission

import data.k8s.matches
deny[{
	"id": "loadbalancer-service-quota",
	"resource": {"kind": "services", "namespace": namespace, "name": name},
	"resolution": {"message": "you cannot have more than 2 loadbalancer services in each namespace"},
}] {
    matches[["services", namespace, any_name, matched_services]]
    count(matched_services) > 2
    not re_match("^(openshift-*|kube-*)", namespace)
}