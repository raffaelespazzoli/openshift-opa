package authorization
import data.k8s.matches

##############################################################################
#
# Policy : denies cluster-admin users access to read secrets in administrative projects 
# 
# 
#
##############################################################################

deny[{
	"id": "unreadable-secret",
	"resource": {"kind": "secrets", "namespace": namespace, "name": name},
	"resolution": {"message": "cluster administrator are not allowed to read secrets in non-administrative namespaces"},
}] {   
	matches[["secrets", namespace, name, resource]]
	resource.spec.resourceAttributes.verb = "get"
	resource.spec.group[_] = "cluster-admin"
	not re_match("^(openshift-*|kube-*)", resource.spec.resourceAttributes.namespace)
}