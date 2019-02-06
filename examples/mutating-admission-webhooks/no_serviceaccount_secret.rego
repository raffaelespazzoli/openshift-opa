package admission

import data.k8s.matches

##############################################################################
#
# Policy : Construct JSON Patch for annotating boject with foo=bar if it is
# annotated with "test-mutation"
#
##############################################################################

default no_sa_annotation = "requires-service-account-secret"

deny[{
    "id": "no-serviceaccount-secret",
    "resource": {"kind": "pods", "namespace": namespace, "name": name},
    "resolution": {"patches":  p, "message" : "service account secret not mounted"},
}] {
    matches[["pods", namespace, name, matched_pod]]
    isCreateOrUpdate(matched_pod)
    isMissingOrFalseAnnotation(matched_pod, no_sa_annotation)
    p = [{"op": "add", "path": "/spec/automountServiceAccountToken", "value": "false"}]
}

isCreateOrUpdate(obj) {
	obj.operation == "CREATE"
}

isCreateOrUpdate(obj) {
	obj.operation == "UPDATE"
}

isMissingOrFalseAnnotation(obj, annotation) {
    not obj.object.metadata["annotations"][annotation]
}

isMissingOrFalseAnnotation(obj, annotation) {
	obj.object.metadata["annotations"][annotation] != true
}