package admission


lb_svc1 = {
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

lb_svc2 = {
    "kind": {
        "group": "",
        "kind": "Service",
        "version": "v1",
    },
    "namespace": "myproject",
    "object": {
        "metadata": {
            "creationTimestamp": "2018-10-30T23:30:00Z",
            "name": "myservice2",
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

test_deny_loadbalancer_service2 {
    count(deny) = 0
        with data.kubernetes.services.myproject.myservice as lb_svc1
        with data.kubernetes.services.myproject.myservice2 as lb_svc2
}
test_deny_loadbalancer_service3 {
    result := deny[{"id": id, "resource": {"kind": "services", "namespace": namespace, "name": name}, "resolution": resolution}] with data.kubernetes.services.myproject.myservice as lb_svc1 with data.kubernetes.services.myproject.myservice2 as lb_svc2 with data.kubernetes.services.myproject.myservice3 as lb_svc2
    result[_].message = "you cannot have more than 2 loadbalancer services in each namespace"
}