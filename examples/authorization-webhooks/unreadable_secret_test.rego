package authorization

test_deny_admin {
	 result := deny[{"id": id, "resource": {"kind": "secrets", "namespace": "secret_namespace", "name": "ciao"}, "resolution": resolution}] with data.kubernetes.secrets.secret_namespace.ciao as {
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
  result[_].message = "cluster administrator are not allowed to read secrets in non-administrative namespaces"
}

 test_allow_user {
 	 not deny[{"id": "unreadable-secret", "resource": {"kind": "secrets", "namespace": "secret_namespace", "name": "ciao"}, "resolution": {"message": "cluster administrator are not allowed to read secrets in non-administrative namespaces"}}] with data.kubernetes.secrets.secret_namespace.ciao as {
 		"kind": "SubjectAccessReview",
 		"apiVersion": "authorization.k8s.io/v1beta1",
 		"spec": {
 			"resourceAttributes": {
             "namespace": "secret_namespace",
             "verb": "get",
             "resource": "secrets",
             "name": "ciao"
 			},
 			"user": "alice",
 			"group": ["user"],
 		},
 	}
 }

 test_allow_admin_kube_namespace {
 	 not deny[{"id": "unreadable-secret", "resource": {"kind": "secrets", "namespace": "kube-system", "name": "policies"}, "resolution": {"message": "cluster administrator are not allowed to read secrets in non-administrative namespaces"}}] with data.kubernetes.secrets["kube-system"].policies as {
 		"kind": "SubjectAccessReview",
 		"apiVersion": "authorization.k8s.io/v1beta1",
 		"spec": {
 			"resourceAttributes": {
             "namespace": "kube-system",
             "verb": "get",
             "resource": "secrets",
             "name": "policies"
 			},
 			"user": "admin",
 			"group": ["cluster-admin"],
 		},
 	}
 }