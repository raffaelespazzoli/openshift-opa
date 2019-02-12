package admission


lb_svc = {
    "kind": {
        "group": "",
        "kind": "Service",
        "version": "v1",
    },
    "namespace": "myproject",
    "object": {
        "metadata": {
            "creationTimestamp": "2018-10-30T23:30:00Z",
            "name": "myservice",
            "namespace": "myproject",
            "uid": "b82becfa-dc9b-11e8-9aa6-080027ca3112",
        },
        "spec": {
            "clusterIP": "10.97.228.185",
            "externalTrafficPolicy": "Cluster",
            "ports": [{
                "nodePort": 30431,
                "port": 80,
                "protocol": "TCP",
                "targetPort": 9376,
            }],
            "selector": {"app": "MyApp"},
            "sessionAffinity": "None",
            "type": "LoadBalancer",
        },
        "status": {"loadBalancer": {}},
    },
    "oldObject": null,
    "operation": "CREATE",
    "resource": {
        "group": "",
        "resource": "services",
        "version": "v1",
    },
    "uid": "b82bef5f-dc9b-11e8-9aa6-080027ca3112",
    "userInfo": {
        "groups": [
            "system:masters",
            "system:authenticated",
        ],
        "username": "minikube-user",
    },
}

existing_svc1 = {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "name": "existingsvc1",
        "namespace": "myproject",
    },
    "spec": {
        "clusterIP": "1.2.3.4",
        "ports": [
            {
                "name": "http",
                "port": 8080,
                "protocol": "TCP",
                "targetPort": 8080
            }
        ],
        "selector": {
            "app": "myapp"
        },
        "type": "LoadBalancer"
    }
}

existing_svc2 = {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "name": "existingsvc2",
        "namespace": "myproject",
    },
    "spec": {
        "clusterIP": "1.2.3.4",
        "ports": [
            {
                "name": "http",
                "port": 8080,
                "protocol": "TCP",
                "targetPort": 8080
            }
        ],
        "selector": {
            "app": "myapp"
        },
        "type": "LoadBalancer"
    }
}

test_deny_loadbalancer_service2 {
    count(deny) = 0
        with data.kubernetes.services.myproject.myservice as lb_svc
        with data.kubernetes.services.myproject.myservice2 as existing_svc1
}
test_deny_loadbalancer_service3 {
    result := deny[{"id": id, "resource": {"kind": "services", "namespace": namespace, "name": name}, "resolution": resolution}] with data.kubernetes.services.myproject.exitingsvc1 as existing_svc1 with data.kubernetes.services.myproject.existingsvc2 as existing_svc2 with data.kubernetes.services.myproject.myservice as lb_svc
    result[_].message = "you cannot have more than 2 loadbalancer services in each namespace"
}