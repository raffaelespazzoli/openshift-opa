package authorization
import data.k8s.matches

##############################################################################
#
# Policy : denies read to secrets to user in group developers 
# 
# 
#
##############################################################################

deny[{
	"id": "unreadable-secret",
	"resource": {"kind": "secrets", "namespace": namespace, "name": name},
	"resolution": {"message": "cluster administrator are not allowed to read secrets in non-administrative namespaces"},
}] {   
	matches[["secrets", namespace, name, input]]
	re_match("^(get)$", input.spec.resourceAttributes.verb)
  re_match("^(cluster-admin)$", input.spec.resourceAttributes.group) 
	not re_match("^(openshift-*|kube-*)$", namespace)
}