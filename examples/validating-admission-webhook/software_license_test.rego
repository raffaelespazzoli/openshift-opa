package admission


software_license_pod1 = {
   "uid":"0df28fbd-5f5f-11e8-bc74-36e6bb280816",
   "kind":{
      "group":"",
      "version":"v1",
      "kind":"Pod"
   },
   "resource":{
      "group":"",
      "version":"v1",
      "resource":"pods"
   },
   "namespace":"myproject1",
   "operation":"CREATE",
   "userInfo":{
      "username":"system:serviceaccount:kube-system:replicaset-controller",
      "uid":"a7e0ab33-5f29-11e8-8a3c-36e6bb280816",
      "groups":[
         "system:serviceaccounts",
         "system:serviceaccounts:kube-system",
         "system:authenticated"
      ]
   },
   "object":{
      "metadata":{
         "name":"myimage",
         "namespace":"myproject1"
      },
      "spec":{
         "containers":[
            {
               "image":"myrepo/myimage:v3.2",
               "imagePullPolicy":"IfNotPresent",
               "name":"mysql",
               "resources":{
                  "requests":{
                     "cpu":"300m",
                     "memory":"512Mi"
                  },
                  "limits":{
                     "cpu":"1",
                     "memory":"1Gi"
                  }
               }
            },
            {
               "image":"httpd:latest",
               "imagePullPolicy": "Always",
               "name":"httpd",
               "resources":{
                  "requests":{
                     "cpu":"1",
                     "memory":"2048Mi"
                  },
                  "limits":{
                     "cpu":"1",
                     "memory":"4096Mi"
                  }
               }
            }
         ],
         "restartPolicy":"Always",
         "terminationGracePeriodSeconds":30
      }
   },
   "oldObject":null
}

software_license_pod2 = {
   "uid":"0df28fbd-5f5f-11e8-bc74-36e6bb280816",
   "kind":{
      "group":"",
      "version":"v1",
      "kind":"Pod"
   },
   "resource":{
      "group":"",
      "version":"v1",
      "resource":"pods"
   },
   "namespace":"myproject2",
   "operation":"CREATE",
   "userInfo":{
      "username":"system:serviceaccount:kube-system:replicaset-controller",
      "uid":"a7e0ab33-5f29-11e8-8a3c-36e6bb280816",
      "groups":[
         "system:serviceaccounts",
         "system:serviceaccounts:kube-system",
         "system:authenticated"
      ]
   },
   "object":{
      "metadata":{
         "name":"couchbase",
         "namespace":"myproject2"
      },
      "spec":{
         "containers":[
            {
               "image":"couchbase:6.0.0",
               "imagePullPolicy":"IfNotPresent",
               "name":"couchbase",
               "resources":{
                  "requests":{
                     "cpu":"700m",
                     "memory":"768m"
                  },
                  "limits":{
                     "cpu":"700m",
                     "memory":"768m"
                  }
               }
            }
         ],
         "restartPolicy":"Always",
         "terminationGracePeriodSeconds":30
      }
   },
   "oldObject":null
}

software_license_pod3 = {
   "uid":"0df28fbd-5f5f-11e8-bc74-36e6bb280816",
   "kind":{
      "group":"",
      "version":"v1",
      "kind":"Pod"
   },
   "resource":{
      "group":"",
      "version":"v1",
      "resource":"pods"
   },
   "namespace":"myproject2",
   "operation":"CREATE",
   "userInfo":{
      "username":"system:serviceaccount:kube-system:replicaset-controller",
      "uid":"a7e0ab33-5f29-11e8-8a3c-36e6bb280816",
      "groups":[
         "system:serviceaccounts",
         "system:serviceaccounts:kube-system",
         "system:authenticated"
      ]
   },
   "object":{
      "metadata":{
         "name":"myimage",
         "namespace":"myproject2"
      },
      "spec":{
         "containers":[
            {
               "image":"myrepo/myimage:v3.2",
               "imagePullPolicy":"IfNotPresent",
               "name":"mysql",
               "resources":{
                  "requests":{
                     "cpu":"500",
                     "memory":"768Mi"
                  },
                  "limits":{
                     "cpu":"700m",
                     "memory":"768m"
                  }
               }
            },
         ],
         "restartPolicy":"Always",
         "terminationGracePeriodSeconds":30
      }
   },
   "oldObject":null
}

test_deny_software_license {
    count(deny) = 0
        with data.kubernetes.pods.myproject1.mysql as software_license_pod1
        with data.kubernetes.pods.myproject2.couchbase as software_license_pod2
}

test_invalid_cmdb_integration {
    result := deny[{"id": id, "resolution": resolution}] with data.kubernetes.pods.myproject1.mysql as software_license_pod1 with data.kubernetes.pods.myproject2.couchbase as software_license_pod2 with data.kubernetes.pods.myproject2.mysql as software_license_pod3
    result[_].message = "we cannot have more than 500 total cpu core for the myrepo/myimage:v3.2 workload"
}