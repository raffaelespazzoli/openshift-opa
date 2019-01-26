package authorization

# test_allow_user {
# 	 not deny[{"id": "unreadable-secret", "resource": {"kind": "secrets", "namespace": "secret_namespace", "name": "ciao"}, "resolution": {"message": "cluster administrator are not allowed to read secrets in non-administrative namespaces"}}] with data.kubernetes.secrets.secret_naemspace.ciao as {
# 		"kind": "SubjectAccessReview",
# 		"apiVersion": "authorization.k8s.io/v1beta1",
# 		"spec": {
# 			"resourceAttributes": {
#             "namespace": "secret_namespace",
#             "verb": "get",
#             "resource": "secrets",
#             "name": "ciao"
# 			},
# 			"user": "alice",
# 			"group": ["cluster-admin"],
# 		},
# 	}
# }

test_deny_admin {
	 result := deny[{"id": _id, "resource": {"kind": "secrets", "namespace": "secret_namespace", "name": "ciao"}, "resolution": {"message": _msg}}] with data.kubernetes.secrets.secret_naemspace.ciao as {
		"kind": "SubjectAccessReview",
		"apiVersion": "authorization.k8s.io/v1beta1",
		"spec": {
			"resourceAttributes": {
            "namespace": "secret_namespace",
            "verb": "get",
            "resource": "secrets",
            "name": "ciao"
			},
			"user": "admin",
			"group": ["cluster-admin"],
		},
	}
  result[_].id = "unreadable-secret"
}

# test_allow_user {
# 	 not deny[{"id": "unreadable_secret", "resource": {"kind": "secrets", "namespace": ""}, "resolution": {"message": ""}}] with data.kubernetes.secrets[""].example as {
# 		"kind": "SubjectAccessReview",
# 		"apiVersion": "authorization.k8s.io/v1beta1",
# 		"spec": {
# 			"resourceAttributes": {
#             "namespace": "secret_namespace",
#             "verb": "get",
#             "resource": "secrets"
# 			},
# 			"user": "alice",
# 			"group": ["user"],
# 		},
# 	}
# }

# test_developer_not_allow {
# 	result := deny[{"id": id, "resource": {"kind": "secrets", "namespace": ""}, "resolution": resolution}] with data.kubernetes.secrets[""].example as {
# 		"kind": "SubjectAccessReview",
# 		"apiVersion": "authorization.k8s.io/v1beta1",
# 		"spec": {
#             "resourceAttributes": {
#             "namespace": "secret_namespace",
#             "verb": "get",
#             "group": "core",
#             "resource": "secrets"
#             },
#             "user": "raffa",
#             "group": [
#             "developers",
#             "group2"
#             ]
# 		},
# 	}

# 	result[_].message == "You are not able to get secrets"

# }



# test_sa_allow {
#     deny = set() with input as {
#       "apiVersion": "authorization.k8s.io/v1beta1",
#       "kind": "SubjectAccessReview",
#       "spec": {
#         "resourceAttributes": {
#           "namespace": "secret_namespace",
#           "verb": "get",
#           "group": "core",
#           "resource": "secrets",
#           "name": "ciao"
#         },
#         "user": "default",
#         "group": [
#           "serviceacconts"
#         ]
#       }
#     }
# }

# test_developer_not_allow {
#     x := deny with input as {   
#       "apiVersion": "authorization.k8s.io/v1beta1",
#       "kind": "SubjectAccessReview",
#       "spec": {
#         "resourceAttributes": {
#           "namespace": "secret_namespace",
#           "verb": "get",
#           "group": "core",
#           "resource": "secrets",
#           "name":"ciao"
#         },
#         "user": "raffa",
#         "group": [
#           "developers",
#           "group2"
#         ]
#       }
#     }
#     count(x) == 1
#     x[violation]
#     violation.id == "unreadable secret"
# }