# Open Policy Agent

## Install

Instructions to deploy on OpenShift:

Indetify the value of the openshift service caBundle.
One way to do is to run:

```shell
SECRET=$(oc describe sa default -n default | grep 'Tokens:' | awk '{print $2}')
CA_BUNDLE=$(oc get secret $SECRET -n default -o "jsonpath={.data['service-ca\.crt']}")
```

Deploy the helm chart:

```shell
oc new-project opa
helm template ./charts/open-policy-agent --namespace opa --set kubernetes_policy_controller.image_tag=2.0 --set kubernetes_policy_controller.image=quay.io/raffaelespazzoli/kubernetes-policy-controller --set caBundle=$CA_BUNDLE --set log_level=debug | oc apply -f  - -n opa
```

This configurations will enforce rules only on those namespaces with the following label `opa-controlled=true`. This is done to have a "safe" deployment. You can easiliy customize the helm template to change this rule.

### Enable authorization

If you want to enable authorization, you need to do the following:

1. Copy the ocp-policy-controller.kubeconfig file to the `/etc/origin/master` directory in each of your masters.
2. Edit the master-config.yaml file adding the following:

```yaml
kubernetesMasterConfig:
...
  apiServerArguments:
...
    authorization-mode:
    - Node
    - Webhook
    - RBAC
    authorization-webhook-config-file:
    - /etc/origin/master/opa-policy-controller.kubeconfig  
```

These above steps are intentionally left manual because the are significnaly differetn between the 3.x and 4.x version of OCP.

## Examples

### no IfnotPresent image pull policy and latest images

This rule will prevent users from deplying images with the IfNotPresent image pull policy and the latest tag in the image.

Run the following command to deploy the rule.

```shell
oc create configmap no-ifnotpresent-latest-rule --from-file=./examples/validating-admission-webhook/latest_and_IfNotPresent.rego -n opa
```

Once the rule is deployed run the following:
```shell
oc new-project ifnotporesent-latest-opa-test
oc label ns ifnotporesent-latest-opa-test opa-controlled=true
oc apply -f ./examples/validating-admission-webhook/latest_and_IfNotPresent_test.yaml -n ifnotporesent-latest-opa-test
```
you should get an error.

To clean up run the following:
```shell
oc delete project ifnotporesent-latest-opa-test
oc delete configmap no-ifnotpresent-latest-rule -n opa
```

## Quota on LoadBalancer service types

LoadBalancer type services are billable resorces in clud deploymen tso it might be a good idea to put a quota on them.
In this example the quota is 2 per namespace.

Run the following command to deploy the rule.

```shell
oc create configmap loadbalancer-quota-rule --from-file=./examples/validating-admission-webhook/loadbalancer_quota_test.rego -n opa
```

Once the rule is deployed run the following:

```shell
oc new-project loadbalancer-quota-opa-test
oc label ns loadbalancer-quota-opa-test opa-controlled=true
oc apply -f ./examples/validating-admission-webhook/loadbalancer_quota_test1.yaml -n loadbalancer-quota-opa-test
```
wait a few minutes for opa to catch up with the cluster status then type:
```
oc apply -f ./examples/validating-admission-webhook/loadbalancer_quota_test2.yaml -n loadbalancer-quota-opa-test
```
you should get an error.

To clean up run the following:
```shell
oc delete project loadbalancer-quota-opa-test
oc delete configmap loadbalancer-quota-rule -n opa
```

## CMDB Integration

Sometimes apps deployed in OpenShift need to be referrable back to a CMDB database. You can do that with label. This rule enforces that the following label are defined:

- cmdb_id
- emergency_contact
- tier

Run the following command to deploy the rule.

```shell
oc create configmap cmdb-integration-rule --from-file=./examples/validating-admission-webhook/cmdb_integration.rego -n opa
```

Once the rule is deployed run the following:

```shell
oc new-project cmdb-integration-test
oc label ns cmdb-integration-test opa-controlled=true
oc apply -f ./examples/validating-admission-webhook/cmdb_integration_test.yaml -n cmdb-integration-test
```

you should get an error.

To clean up run the following:

```shell
oc delete project cmdb-integration-test
oc delete configmap cmdb-integration-rule -n opa
```