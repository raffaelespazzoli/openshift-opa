package admission

test_allow_one {
	 not deny[{"id": id, "resource": {"kind": "services", "namespace": "external-dns", "name": "external-coredns-coredns"}, "resolution": resolution}] with data.kubernetes.services.["external-dns"].["external-coredns-coredns"] as 
		{
			"apiVersion": "v1",
			"kind": "Service",
			"metadata": {
				"annotations": {
					"kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"v1\",\"kind\":\"Service\",\"metadata\":{\"annotations\":{\"prometheus.io/port\":\"9153\",\"prometheus.io/scrape\":\"true\"},\"labels\":{\"app\":\"coredns\",\"chart\":\"coredns-1.2.4\",\"heritage\":\"Tiller\",\"release\":\"external-coredns\"},\"name\":\"external-coredns-coredns\",\"namespace\":\"external-dns\"},\"spec\":{\"ports\":[{\"port\":53,\"protocol\":\"UDP\",\"targetPort\":8053}],\"selector\":{\"app\":\"coredns\",\"release\":\"external-coredns\"},\"type\":\"LoadBalancer\"}}\n",
					"prometheus.io/port": "9153",
					"prometheus.io/scrape": "true"
				},
				"creationTimestamp": "2019-01-29T01:24:04Z",
				"labels": {
					"app": "coredns",
					"chart": "coredns-1.2.4",
					"heritage": "Tiller",
					"release": "external-coredns"
				},
				"name": "external-coredns-coredns",
				"namespace": "external-dns",
				"resourceVersion": "32744764",
				"selfLink": "/api/v1/namespaces/external-dns/services/external-coredns-coredns",
				"uid": "90fb6411-2364-11e9-8cf3-fa163ea7aaa3"
			},
			"spec": {
				"clusterIP": "172.30.46.222",
				"externalTrafficPolicy": "Cluster",
				"ports": [
					{
						"nodePort": 32153,
						"port": 53,
						"protocol": "UDP",
						"targetPort": 8053
					}
				],
				"selector": {
					"app": "coredns",
					"release": "external-coredns"
				},
				"sessionAffinity": "None",
				"type": "LoadBalancer"
			},
			"status": {
				"loadBalancer": {
					"ingress": [
						{
							"ip": "192.168.99.134"
						}
					]
				}
			}
		}
}

# test_deny_three {
# 	 not deny[{"id": id, "resource": {"kind": "services", "namespace": "external-dns", "name": "external-coredns-coredns"}, "resolution": resolution}] with data.kubernetes.services.external-dns.external-coredns-coredns as 
# 		{
# 			"apiVersion": "v1",
# 			"kind": "Service",
# 			"metadata": {
# 				"annotations": {
# 					"kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"v1\",\"kind\":\"Service\",\"metadata\":{\"annotations\":{\"prometheus.io/port\":\"9153\",\"prometheus.io/scrape\":\"true\"},\"labels\":{\"app\":\"coredns\",\"chart\":\"coredns-1.2.4\",\"heritage\":\"Tiller\",\"release\":\"external-coredns\"},\"name\":\"external-coredns-coredns\",\"namespace\":\"external-dns\"},\"spec\":{\"ports\":[{\"port\":53,\"protocol\":\"UDP\",\"targetPort\":8053}],\"selector\":{\"app\":\"coredns\",\"release\":\"external-coredns\"},\"type\":\"LoadBalancer\"}}\n",
# 					"prometheus.io/port": "9153",
# 					"prometheus.io/scrape": "true"
# 				},
# 				"creationTimestamp": "2019-01-29T01:24:04Z",
# 				"labels": {
# 					"app": "coredns",
# 					"chart": "coredns-1.2.4",
# 					"heritage": "Tiller",
# 					"release": "external-coredns"
# 				},
# 				"name": "external-coredns-coredns",
# 				"namespace": "external-dns",
# 				"resourceVersion": "32744764",
# 				"selfLink": "/api/v1/namespaces/external-dns/services/external-coredns-coredns",
# 				"uid": "90fb6411-2364-11e9-8cf3-fa163ea7aaa3"
# 			},
# 			"spec": {
# 				"clusterIP": "172.30.46.222",
# 				"externalTrafficPolicy": "Cluster",
# 				"ports": [
# 					{
# 						"nodePort": 32153,
# 						"port": 53,
# 						"protocol": "UDP",
# 						"targetPort": 8053
# 					}
# 				],
# 				"selector": {
# 					"app": "coredns",
# 					"release": "external-coredns"
# 				},
# 				"sessionAffinity": "None",
# 				"type": "LoadBalancer"
# 			},
# 			"status": {
# 				"loadBalancer": {
# 					"ingress": [
# 						{
# 							"ip": "192.168.99.134"
# 						}
# 					]
# 				}
# 			}
# 		}
# }