package admission

import data.k8s.matches

#all deployments must have the cmdb_id, emergency_contant an tier labels

deny[{
	"id": "cmdb-labels",
	"resource": {"kind": "deployments", "namespace": namespace, "name": name},
	"resolution": {"message": "all deployments must have the cmdb_id, emergency_contant an tier labels"},
}] {
    matches[["deployments", namespace, name, matched_deployment]]
    matched_deployment.metadata.labels.cmdb_id
    matched_deployment.metadata.labels.emergency_contact
    matched_deployment.metadata.labels.tier
}