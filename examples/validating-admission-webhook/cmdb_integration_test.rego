package admission


cmdb_deployment1 = {
   "kind":{
      "group":"apps",
      "kind":"Deployment",
      "version":"v1"
   },
   "namespace":"test",
   "object":{
      "metadata":{
         "creationTimestamp":"None",
         "name":"hello",
         "namespace":"test",
         "labels": {
             "cmdb_id":"foo",
             "emergency_contact":"foo",
             "tier":"foo"
         }
      },
      "spec":{
         "progressDeadlineSeconds":600,
         "replicas":3,
         "revisionHistoryLimit":10,
         "selector":{
            "matchLabels":{
               "app":"hello"
            }
         },
         "strategy":{
            "rollingUpdate":{
               "maxSurge":"25%",
               "maxUnavailable":"25%"
            },
            "type":"RollingUpdate"
         },
         "template":{
            "metadata":{
               "creationTimestamp":"None",
               "labels":{
                  "app":"hello"
               }
            },
            "spec":{
               "containers":[
                  {
                     "image":"jmsearcy/hello:1.5",
                     "imagePullPolicy":"IfNotPresent",
                     "name":"hello",
                     "ports":[
                        {
                           "containerPort":8080,
                           "protocol":"TCP"
                        }
                     ],
                     "resources":{

                     },
                     "terminationMessagePath":"/dev/termination-log",
                     "terminationMessagePolicy":"File"
                  }
               ],
               "dnsPolicy":"ClusterFirst",
               "restartPolicy":"Always",
               "schedulerName":"default-scheduler",
               "securityContext":{},
               "terminationGracePeriodSeconds":30
            }
         }
      },
      "status":{

      }
   },
   "oldObject":"None",
   "operation":"CREATE",
   "resource":{
      "group":"apps",
      "resource":"deployments",
      "version":"v1"
   },
   "uid":"96ab6176-dc7e-11e8-84d0-da6ee68491b2",
   "userInfo":{
      "groups":[
         "system:authenticated"
      ],
      "username":"cc9ddda6c7ba0887fc4e0d483a907363d20df2b4"
   }
}

cmdb_deployment2 = {
   "kind":{
      "group":"apps",
      "kind":"Deployment",
      "version":"v1"
   },
   "namespace":"test",
   "object":{
      "metadata":{
         "creationTimestamp":"None",
         "name":"hello2",
         "namespace":"test",
         "labels": {
             "cmdb_id":"foo",
             "tier":"foo"
         }
      },
      "spec":{
         "progressDeadlineSeconds":600,
         "replicas":3,
         "revisionHistoryLimit":10,
         "selector":{
            "matchLabels":{
               "app":"hello2"
            }
         },
         "strategy":{
            "rollingUpdate":{
               "maxSurge":"25%",
               "maxUnavailable":"25%"
            },
            "type":"RollingUpdate"
         },
         "template":{
            "metadata":{
               "creationTimestamp":"None",
               "labels":{
                  "app":"hello2"
               }
            },
            "spec":{
               "containers":[
                  {
                     "image":"jmsearcy/hello:1.5",
                     "imagePullPolicy":"IfNotPresent",
                     "name":"hello2",
                     "ports":[
                        {
                           "containerPort":8080,
                           "protocol":"TCP"
                        }
                     ],
                     "resources":{

                     },
                     "terminationMessagePath":"/dev/termination-log",
                     "terminationMessagePolicy":"File"
                  }
               ],
               "dnsPolicy":"ClusterFirst",
               "restartPolicy":"Always",
               "schedulerName":"default-scheduler",
               "securityContext":{},
               "terminationGracePeriodSeconds":30
            }
         }
      },
      "status":{

      }
   },
   "oldObject":"None",
   "operation":"CREATE",
   "resource":{
      "group":"apps",
      "resource":"deployments",
      "version":"v1"
   },
   "uid":"96ab6176-dc7e-11e8-84d0-da6ee68491b2",
   "userInfo":{
      "groups":[
         "system:authenticated"
      ],
      "username":"cc9ddda6c7ba0887fc4e0d483a907363d20df2b4"
   }
}

test_valid_cmdb_integration {   
   count(deny) = 0 with data.kubernetes.deployments.test.hello as cmdb_deployment1
}

test_invalid_cmdb_integration {
    result := deny[{"id": id, "resource": {"kind": "deployments", "namespace": namespace, "name": name}, "resolution": resolution}] with data.kubernetes.deployments.test.hello2 as cmdb_deployment2
    result[_].message = "all deployments must have the cmdb_id, emergency_contant an tier labels"
}