# normal namespoaces are allowed to create only 2 loadbalancer type services
package admission

import data.k8s.matches

deny[{
	"id": "loadbalancer-service-quota",
	"resource": {"kind": "services", "namespace": namespace, "name": name},
	"resolution": {"message": "you cannot have more than 2 loadbalancer services in each namespace"},
}] {
    service := data.kubernetes.services[namespace][name]
    loadbalancers := [s | s := data.kubernetes.services[namespace][_]; s.object.spec.type == "LoadBalancer"]
    2 < count(loadbalancers)

}