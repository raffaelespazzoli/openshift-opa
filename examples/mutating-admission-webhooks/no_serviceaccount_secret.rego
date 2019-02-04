package admission

import data.k8s.matches

##############################################################################
#
# Policy : Construct JSON Patch for annotating boject with foo=bar if it is
# annotated with "test-mutation"
#
##############################################################################

deny[{
    "id": "no-serviceaccount-secret",
    "resource": {"kind": "pods", "namespace": namespace, "name": name},
    "resolution": {"patches":  p, "message" : "service account secret not mounted"},
}] {
    matches[["pods", namespace, name, matched_pod]]
    matched_pod.metadata.annotations["requires-service-account-secret"] != true
    p = [{"op": "add", "path": "spec/automountServiceAccountToken", "value": "false"}]
}