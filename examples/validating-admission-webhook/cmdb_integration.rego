package admission

import data.k8s.matches

#all deployments must have the cmdb_id, emergency_contant an tier labels

required_labels = ["cmdb_id", "emergency_contact", "tier"]

deny[{
	"id": "cmdb-labels",
	"resource": {"kind": "deployments", "namespace": namespace, "name": name},
	"resolution": {"message": "all deployments must have the cmdb_id, emergency_contant an tier labels"},
}] {
    matches[["deployments", namespace, name, matched_deployment]]

    l := required_labels[_]
    not check_labels(matched_deployment.object.metadata.labels, l)
    
}

check_labels(obj, key) {
   obj[key]
}