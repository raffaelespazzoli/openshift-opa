package authorization

##############################################################################
#
# Policy : denies read to secrets to user in group developers 
# 
# 
#
##############################################################################

deny[{
	"id": "unreadable secret",
	"resource": {"kind": "secrets", "namespace": "secret_namespace", "name": name},
	"resolution": {"message": "Your're not allowed to see secret in the namespace 'secret_namespace'"},
}] {   
	input.kind = "SubjectAccessReview"
    input.spec.group[_] = "developers"
    input.spec.resourceAttributes.verb = "get"
	name := input.spec.resourceAttributes.name
}