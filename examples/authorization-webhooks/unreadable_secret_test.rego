package authorization



test_sa_allow {
    deny = set() with input as {
      "apiVersion": "authorization.k8s.io/v1beta1",
      "kind": "SubjectAccessReview",
      "spec": {
        "resourceAttributes": {
          "namespace": "secret_namespace",
          "verb": "get",
          "group": "core",
          "resource": "secrets",
          "name": "ciao"
        },
        "user": "default",
        "group": [
          "serviceacconts"
        ]
      }
    }
}

test_developer_not_allow {
    x := deny with input as {   
      "apiVersion": "authorization.k8s.io/v1beta1",
      "kind": "SubjectAccessReview",
      "spec": {
        "resourceAttributes": {
          "namespace": "secret_namespace",
          "verb": "get",
          "group": "core",
          "resource": "secrets",
          "name":"ciao"
        },
        "user": "raffa",
        "group": [
          "developers",
          "group2"
        ]
      }
    }
    count(x) == 1
    x[violation]
    violation.id == "unreadable secret"
}