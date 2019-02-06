package admission

pod1 = {
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
   "namespace":"myproject",
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
         "namespace":"myproject",
         "annotations": {
             "requires-service-account-secret": true
         }
      },
      "spec":{
         "containers":[
            {
               "image":"couchbase:6.0.0",
               "imagePullPolicy":"IfNotPresent",
               "name":"couchbase"
            }
         ],
         "restartPolicy":"Always",
         "terminationGracePeriodSeconds":30
      }
   },
   "oldObject":null
}

pod2 = {
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
   "namespace":"myproject",
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
         "namespace":"myproject"
      },
      "spec":{
         "containers":[
            {
               "image":"myrepo/myimage:v3.2",
               "imagePullPolicy":"IfNotPresent",
               "name":"mysql"
            },
         ],
         "restartPolicy":"Always",
         "terminationGracePeriodSeconds":30
      }
   },
   "oldObject":null
}

test_non_mutation {
    count(deny) = 0
        with data.kubernetes.pods.myproject.couchbase as pod1
}

test_mutation {
    result := deny[{"id": id, "resource": {"kind": "pods", "namespace": namespace, "name": name}, "resolution": resolution}] with data.kubernetes.pods.myproject.mysql as pod2 
    result[_].message = "service account secret not mounted"
    result[_].patches[_].op = "add"
    result[_].patches[_].path = "/spec/automountServiceAccountToken"
    result[_].patches[_].value = "false"
}