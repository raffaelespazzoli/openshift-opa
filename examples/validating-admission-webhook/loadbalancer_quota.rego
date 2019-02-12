# normal namespoaces are allowed to create only 2 loadbalancer type services
package admission

import data.k8s.matches

deny[{
	"id": "loadbalancer-service-quota",
	"resource": {"kind": "services", "namespace": namespace, "name": name},
	"resolution": {"message": "you cannot have more than 2 loadbalancer services in each namespace"},
}] {
    service := data.kubernetes.services[namespace][name]

    # Verify current object is a LoadBalancer Service
    service["object"]["spec"]["type"] == "LoadBalancer"
 
    loadbalancers := [s | s := data.kubernetes.services[namespace][_]; s.spec.type == "LoadBalancer"]
    count(loadbalancers) >= 2

}